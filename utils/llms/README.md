# llms

Configs for running local GGUF models with [llama.cpp](https://github.com/ggerganov/llama.cpp)'s `llama-server`, and for exposing them to [Pi](https://pi.dev/) as agent models.

## Downloading models

`llama-server` can pull a model straight from Hugging Face with `-hf`, instead of requiring a manually downloaded path:

```bash
llama-server -hf unsloth/gemma-4-26B-A4B-it-qat-GGUF:UD-Q4_K_XL
```

- `unsloth/gemma-4-26B-A4B-it-qat-GGUF` is the HF repo.
- `:UD-Q4_K_XL` selects the quantization variant (the file matching that tag inside the repo). Omit it to get prompted, or to fall back to the repo's default quant.

This downloads into the standard Hugging Face cache — the same layout every `model =` path in `models.ini` already points at:

```
~/.cache/huggingface/hub/models--unsloth--gemma-4-26B-A4B-it-qat-GGUF/snapshots/.../gemma-4-26B-A4B-it-qat-UD-Q4_K_XL.gguf
                                 └────────────────┬─────────────────┘                                      └───┬────┘
                                              org/repo                                                     quant tag
```

So the usual flow for adding a new model is: run `llama-server -hf ...` once (or just to try the model interactively), then find the downloaded `.gguf` under that cache path and add a `[section]` to `models.ini` pointing `model =` at it, so it can be launched by name via the preset file afterwards.

The mapping also works in reverse: given any `model =` path already in `models.ini`, you can read `<org>/<repo>:<quant>` straight back out of it and re-run `-hf` with that — useful after a wiped cache or on a new machine. The `<hash>` snapshot directory is tied to whatever commit is current on HF at download time, so a fresh pull may land at a different hash than the one recorded in `models.ini`. If so, update the `model =` path to match the new snapshot dir.

## llama.cpp/models.ini

A "models preset" file: each `[section]` is a model llama-server can serve, selected at launch with `--models-preset ~/.config/llama.cpp/models.ini --model-preset <name>` (or auto-loaded on first request — see `models-autoload` below). Copy to `~/.config/llama.cpp/models.ini` to use; the `llms` shell alias (`home/shell.nix`) points `llama-server` at this path.

`version = 1` at the top of the file declares the models-preset format version, required by `--models-preset`.

### `[*]` — global defaults

Any param below can be set in `[*]` as a default applied to every model section, then overridden inside a specific `[section]` — e.g. `qwen3.8-27b` overrides `n-gpu-layers`/`fit` to force full GPU offload instead of the auto-fit default.

### Per-model params

**Model & hardware**

| Param | Meaning |
|---|---|
| `model` | Absolute path to the `.gguf` weights file. |
| `model-draft` | Absolute path to a separate draft model's `.gguf` weights, used for speculative decoding alongside `spec-type`. |
| `device` | Backend device to offload to. `Vulkan0` is the first GPU on the Vulkan backend (used here instead of CUDA/ROCm for cross-vendor GPU support). |
| `n-gpu-layers` | Number of transformer layers to offload to the GPU. `auto` (paired with `fit = on`) lets llama-server pick automatically; a section can override with an explicit "just offload everything" value like `999` — larger than any model's actual layer count — paired with `fit = off`. |
| `fit` | When `on`, llama-server auto-tunes `n-gpu-layers` to fit available VRAM. Set `off` alongside an explicit `n-gpu-layers` to disable that and force a fixed value. |
| `flash-attn` | Enables the FlashAttention kernel (`on`/`off`/`auto`). Faster and more memory-efficient attention computation; `on` forces it when the backend supports it. |
| `ctx-size` | Context window in tokens — the max combined length of prompt + generated output. Bigger contexts cost more VRAM for the KV cache. |
| `reasoning` | Enables the model's reasoning/thinking-mode output formatting, if its chat template supports it. |
| `cache-type-k` / `cache-type-v` | Quantization applied to the main model's K/V attention cache (e.g. `q8_0` instead of full-precision `f16`). Shrinks KV-cache VRAM usage — what makes long `ctx-size` values (64K–128K) affordable — at a small quality cost. |
| `cache-type-k-draft` / `cache-type-v-draft` | Same K/V cache quantization, applied to the draft model's cache instead of the main model's. |
| `spec-type` | Speculative decoding method. `draft-mtp` uses the model's own Multi-Token Prediction head (`model-draft`) to propose draft tokens instead of running a fully separate draft model. |
| `spec-draft-n-max` | Max number of speculative draft tokens proposed per step before the main model verifies them. |
| `parallel` | Number of concurrent request "slots" the server reserves context for. `1` means one request at a time (no context splitting between parallel chats). |
| `jinja` | Enables Jinja2 chat-template rendering (vs. a hardcoded template). Required for modern models whose chat template does tool-calling / thinking-block formatting. |

**Sampling** — control how the next token is picked from the model's output distribution.

| Param | Meaning |
|---|---|
| `temp` | Temperature. Scales the probability distribution before sampling — lower is more deterministic/focused, higher is more random/creative. |
| `top-k` | Keep only the `k` most likely tokens before sampling, discarding the long tail. |
| `top-p` | Nucleus sampling: keep the smallest set of tokens whose cumulative probability reaches `p`, discard the rest. |
| `min-p` | Discard tokens whose probability is below `min-p` × (probability of the most likely token). A floor relative to the top candidate, rather than a fixed count (`top-k`) or cumulative mass (`top-p`). |
| `repeat-penalty` | Penalizes tokens already seen recently to discourage repetition/loops. `1.0` = no penalty. |
| `presence-penalty` | Flat penalty applied to any token that has appeared at all so far in the output, regardless of how often — discourages reusing the same vocabulary. `0.0` = no penalty. |

## pi/models.json

Registers the llama-server endpoint and its models as an OpenAI-compatible provider for Pi. Copy to `~/.pi/agent/models.json` to use.

| Field | Meaning |
|---|---|
| `baseUrl` | llama-server's OpenAI-compatible API endpoint. |
| `api` | Wire protocol Pi should speak to this endpoint (`openai-completions`). |
| `apiKey` | Placeholder — llama-server doesn't require auth locally. |
| `models[].id` | Must match a `[section]` name in `models.ini` so Pi's model picker maps to the right preset. |
| `models[].contextWindow` | Must match that model's `ctx-size` in `models.ini`, so Pi knows how much context it can use. |
