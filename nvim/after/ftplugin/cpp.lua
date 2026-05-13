-- Pastel semantic highlighting
-- Background: #1E2426

local hl = vim.api.nvim_set_hl

-- =========================================================
-- LSP semantic tokens
-- =========================================================

hl(0, "@lsp.type.namespace", { fg = "#C6A7B2" })

-- Types / classes (high contrast pastel)
hl(0, "@lsp.type.type", { fg = "#D1C4EE", bold = true })
hl(0, "@lsp.type.enum", { fg = "#D1C4EE", bold = true })

-- Functions / methods (darker blue-teal)
hl(0, "@lsp.type.function", { fg = "#6FAEB8" })
hl(0, "@lsp.type.method", { fg = "#6FAEB8" })

hl(0, "@lsp.type.macro", { fg = "#9FBFD9" })

-- Variables (soft sage)
hl(0, "@lsp.type.variable", { fg = "#8FB7A1", bold = true })
hl(0, "@lsp.type.parameter", { fg = "#9FBDB0" })

-- Enum members
hl(0, "@lsp.type.enumMember", { fg = "#E3B3A3", bold = true })
hl(0, "@lsp.type.enumMember.cpp", { fg = "#E3B3A3", bold = true })

-- =========================================================
-- Treesitter keywords & operators
-- =========================================================

hl(0, "@keyword", { fg = "#E2A1A1" })
hl(0, "@keyword.type", { fg = "#D1C4EE", bold = true })
hl(0, "@operator", { fg = "#7FAFB0" })

-- =========================================================
-- Functions
-- =========================================================

hl(0, "@function", { fg = "#6FAEB8" })
hl(0, "@function.call", { fg = "#7FBAC8" }) -- slightly lighter call site

-- =========================================================
-- Types & namespaces
-- =========================================================

hl(0, "@type", { fg = "#CBD6F4", bold = true })
hl(0, "@type.builtin", { fg = "#D1C4EE", bold = true })
hl(0, "@namespace", { fg = "#C6A7B2" })

-- =========================================================
-- Variables
-- =========================================================

hl(0, "@variable", { fg = "#8FB7A1", bold = true })
hl(0, "@variable.parameter", { fg = "#9FBDB0" })
hl(0, "@variable.builtin", { fg = "#739B86", bold = true })

-- =========================================================
-- Numbers & constants
-- =========================================================

hl(0, "@number", { fg = "#E6C58F" })
hl(0, "@constant", { fg = "#E6C58F" })

-- =========================================================
-- Strings
-- =========================================================

-- Runtime strings (pastel orange)
hl(0, "@string", { fg = "#F0B36A" })

-- Include paths / special strings
hl(0, "@string.special", { fg = "#C9B48A", italic = true })
hl(0, "@string.special.path", { fg = "#C9B48A", italic = true })

-- =========================================================
-- Enum fallback (Treesitter)
-- =========================================================

hl(0, "@enumMember", { fg = "#E3B3A3", bold = true })

-- =========================================================
-- Comments
-- =========================================================

hl(0, "@comment", { fg = "#8F9EA3", italic = true })
