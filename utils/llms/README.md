# llms

Configs for running local GGUF models with [llama.cpp](https://github.com/ggerganov/llama.cpp)'s `llama-server`, and for exposing them to [Pi](https://pi.dev/) as agent models.

## llama.cpp/models.ini

A "models preset" file: each `[section]` is a model llama-server can serve, selected at launch with `--models-preset ~/.config/llama.cpp/models.ini --model-preset <name>` (or auto-loaded on first request — see `models-autoload` below). Copy to `~/.config/llama.cpp/models.ini` to use; the `llms` shell alias (`home/shell.nix`) points `llama-server` at this path.

### `[*]` — global defaults

Applied to every model section unless overridden inside it.

| Param | Meaning |
|---|---|
| `models-max` | Max number of models kept loaded in memory at once. `1` means loading a new model unloads the previous one — this box only has VRAM for one model at a time. |
| `models-autoload` | If `1`, llama-server loads the requested model on the first incoming request instead of requiring it to be preloaded at startup. |

### Per-model params

**Model & hardware**

| Param | Meaning |
|---|---|
| `model` | Absolute path to the `.gguf` weights file. |
| `device` | Backend device to offload to. `Vulkan0` is the first GPU on the Vulkan backend (used here instead of CUDA/ROCm for cross-vendor GPU support). |
| `n-gpu-layers` | Number of transformer layers to offload to the GPU. `999` is a "just offload everything" value — larger than any model's actual layer count, so the whole model lands on GPU. |
| `flash-attn` | Enables the FlashAttention kernel (`on`/`off`/`auto`). Faster and more memory-efficient attention computation; `on` forces it when the backend supports it. |
| `ctx-size` | Context window in tokens — the max combined length of prompt + generated output. Bigger contexts cost more VRAM for the KV cache. |
| `ubatch-size` | Physical micro-batch size used while processing the prompt (prefill). Larger values speed up prompt processing at the cost of more compute-buffer memory. |
| `cache-type-k` / `cache-type-v` | Quantization applied to the K/V attention cache (e.g. `q8_0` instead of full-precision `f16`). Shrinks KV-cache VRAM usage — what makes long `ctx-size` values (64K–128K) affordable — at a small quality cost. |
| `parallel` | Number of concurrent request "slots" the server reserves context for. `1` means one request at a time (no context splitting between parallel chats). |
| `jinja` | Enables Jinja2 chat-template rendering (vs. a hardcoded template). Required for modern models whose chat template does tool-calling / thinking-block formatting. |
| `chat-template-kwargs` | Extra JSON kwargs passed into the Jinja chat template. E.g. `{"enable_thinking": true}` turns on a model's reasoning/thinking mode if its template supports the flag. |

**Sampling** — control how the next token is picked from the model's output distribution.

| Param | Meaning |
|---|---|
| `samplers` | Explicit ordered list of sampler stages to apply (e.g. `temperature;top_p;top_k`). When omitted, llama-server uses its built-in default order. |
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
