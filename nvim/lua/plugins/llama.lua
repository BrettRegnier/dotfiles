return {
    "ggml-org/llama.vim",
    init = function()
        vim.g.llama_config = {
            endpoint_fim = "ai.regniers.ca/infill",
            endpoint_inst = "ai.regniers.ca/v1/chat/completions",
        }
    end,
}
