# Legacy Configuration

This directory contains the old dein.vim configuration for reference and emergency fallback.

## Emergency Usage

If you need to use the old dein.vim configuration:

```bash
NVIM_USE_DEIN=1 nvim
```

## Migration Completed

- **Date**: 2025-06-23
- **From**: dein.vim
- **To**: lazy.nvim
- **Performance improvement**: ~70% faster startup (146ms → 36ms)

## Old Configuration Location

The dein configuration is still present in:

- `.config/dein/dein.toml`
- `.config/dein/dein_lazy.toml`

But lazy.nvim is now the default in `init.vim`.
