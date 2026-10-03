# llms

Configs for running local GGUF models with [llama.cpp](https://github.com/ggerganov/llama.cpp)'s `llama-server`, and for exposing them to [Pi](https://pi.dev/) as agent models.

## Models

Each model in `models.ini` is referenced by its Hugging Face repo and quantization rather than a local file path:

```ini
hf-repo = <org>/<repo>:<quant>
```

- `<org>/<repo>` is the HF repo.
- `:<quant>` selects the quantization variant (the file matching that tag inside the repo). Omit it to fall back to the repo's default quant.

`llama-server` downloads the weights into the standard Hugging Face cache (`~/.cache/huggingface/hub/`) the first time the model is loaded, and reuses them afterwards. A wiped cache or a new machine just means a fresh download on first use.

To try a model before adding it, run it directly with the same reference:

```bash
llama-server -hf <org>/<repo>:<quant>
```

To add it permanently, add a `[section]` to `models.ini` with that `hf-repo` and any per-model overrides, then register it in `pi/models.json` (see below).

## llama.cpp/models.ini

A "models preset" file for llama-server's router mode: each `[section]` is a model the server can serve, and the section name is the model ID clients request. Copy to `~/.config/llama.cpp/models.ini` to use; the `llms` shell alias (`home/shell.nix`) starts `llama-server` with `--models-preset` pointing at this path.

Models are loaded on demand when a request names them (`--models-autoload`, enabled by default). `--models-max` caps how many stay loaded at once; the `llms` alias sets it to `1`, so requesting a different model unloads the current one first.

`version = 1` at the top of the file declares the models-preset format version, required by `--models-preset`.

### `[*]` — global defaults

Any param below can be set in `[*]` as a default applied to every model section, then overridden inside a specific `[section]`.

### Per-model params

Every key maps to the `llama-server` CLI flag of the same name (`llama-server --help` lists them all). The ones used in this file:

**Model & hardware**

| Param | Meaning |
|---|---|
| `hf-repo` | Hugging Face model reference (`<org>/<repo>:<quant>`). See [Models](#models). |
| `no-mmproj` | Skip downloading/loading the multimodal projector (vision support) that `hf-repo` otherwise fetches automatically when the repo has one. Saves VRAM for text-only use. |
| `device` | Backend device to offload to. `Vulkan0` is the first GPU on the Vulkan backend (used here instead of CUDA/ROCm for cross-vendor GPU support). |
| `n-gpu-layers` | Number of transformer layers to offload to the GPU. `auto` lets llama-server decide; a value larger than any model's layer count (e.g. `999`) means "offload everything". |
| `fit` | When `on`, llama-server adjusts any params left unset (e.g. layers, context) to fit available VRAM. |
| `flash-attn` | Enables the FlashAttention kernel (`on`/`off`/`auto`). Faster and more memory-efficient attention computation; `on` forces it when the backend supports it. |
| `ctx-size` | Context window in tokens — the max combined length of prompt + generated output. Bigger contexts cost more VRAM for the KV cache. |
| `batch-size` / `ubatch-size` | Logical and physical max batch sizes for prompt processing. Lowering them reduces peak VRAM usage at the cost of slower prompt ingestion. |
| `reasoning` | Enables the model's reasoning/thinking-mode output formatting, if its chat template supports it. |
| `cache-type-k` / `cache-type-v` | Quantization applied to the K/V attention cache (e.g. `q8_0` instead of full-precision `f16`). Shrinks KV-cache VRAM usage — what makes long `ctx-size` values affordable — at a small quality cost. |
| `parallel` | Number of concurrent request "slots" the server reserves context for. `1` means one request at a time (no context splitting between parallel chats). |
| `jinja` | Enables Jinja2 chat-template rendering (vs. a hardcoded template). Required for modern models whose chat template does tool-calling / thinking-block formatting. |

**Speculative decoding** — a cheaper "draft" proposes several tokens ahead and the main model verifies them in one pass, speeding up generation.

| Param | Meaning |
|---|---|
| `spec-type` | Speculative decoding method. `draft-mtp` uses the model's own built-in Multi-Token Prediction head as the draft, so no separate draft model is needed. |
| `spec-draft-n-max` | Max number of draft tokens proposed per step before the main model verifies them. |
| `spec-draft-ngl` | Same as `n-gpu-layers`, for the draft. |
| `spec-draft-type-k` / `spec-draft-type-v` | Same as `cache-type-k` / `cache-type-v`, for the draft's KV cache. `cache-type-k-draft` / `cache-type-v-draft` are aliases for the same options. |

**Sampling** — control how the next token is picked from the model's output distribution. Model cards usually recommend specific values.

| Param | Meaning |
|---|---|
| `temp` | Temperature. Scales the probability distribution before sampling — lower is more deterministic/focused, higher is more random/creative. |
| `top-k` | Keep only the `k` most likely tokens before sampling, discarding the long tail. `0` disables it. |
| `top-p` | Nucleus sampling: keep the smallest set of tokens whose cumulative probability reaches `p`, discard the rest. |
| `min-p` | Discard tokens whose probability is below `min-p` × (probability of the most likely token). A floor relative to the top candidate, rather than a fixed count (`top-k`) or cumulative mass (`top-p`). |
| `repeat-penalty` | Penalizes tokens already seen recently to discourage repetition/loops. `1.0` = no penalty. |
| `presence-penalty` | Flat penalty applied to any token that has appeared at all so far in the output, regardless of how often — discourages reusing the same vocabulary. `0.0` = no penalty. |
| `frequency-penalty` | Penalty that grows with how many times a token has already appeared. `0.0` = no penalty. |

## pi/models.json

Registers the llama-server endpoint and its models as an OpenAI-compatible provider for Pi. Copy to `~/.pi/agent/models.json` to use.

| Field | Meaning |
|---|---|
| `baseUrl` | llama-server's OpenAI-compatible API endpoint. |
| `api` | Wire protocol Pi should speak to this endpoint (`openai-completions`). |
| `apiKey` | Placeholder — llama-server doesn't require auth locally. |
| `models[].id` | Must match a `[section]` name in `models.ini` so Pi's model picker maps to the right preset. |
| `models[].contextWindow` | Must match that model's `ctx-size` in `models.ini`, so Pi knows how much context it can use. |
