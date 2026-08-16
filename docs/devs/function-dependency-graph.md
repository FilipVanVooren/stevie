# Stevie function dependency graph

This is a high-level dependency graph at the assembly-subroutine level. It focuses on the main runtime flow of Stevie rather than every tiny helper. The goal is to show how the editor boots, dispatches keyboard actions, loads files, and triggers lower-level hardware and dialog support.

Note: because this codebase uses bank stubs and far jumps, the same logical routine may be reached from several banks. This graph therefore emphasizes the runtime relationships and ownership, not a strict bank-to-function mapping.

## Main runtime flow

```mermaid
flowchart TD
    A[main.stevie] --> B[mem.sams.setup.stevie]
    A --> C[tv.init]
    A --> D[tv.reset]
    A --> E[pane.colorscheme.load]
    A --> F[mkhook]
    F --> G[edkey.keyscan.hook]
    G --> H[edkey.key.process]

    H --> I[edk.act.left]
    H --> J[edk.act.right]
    H --> K[edk.act.home]
    H --> L[edk.act.end]
    H --> M[edk.act.del_char]
    H --> N[edk.act.ins_line]
    H --> O[edk.act.enter]
    H --> P[edk.act.block.mark]
    H --> Q[edk.act.block.copy]
    H --> R[edk.act.block.delete]
    H --> S[edk.act.cmdb.file.run]
    H --> T[edk.act.cmdb.save]
    H --> U[edk.act.cmdb.print]
    H --> V[edk.fb.char]

    V --> W[fb.refresh]
    V --> X[fb.restore]
    W --> Y[pane.topline]
    W --> Z[pane.botline]
    W --> AA[pane.errline.drawcolor]

    B --> AB[mem.sams.set.boot]
    B --> AC[mem.sams.set.stevie]

    A --> AD[task.vdp.panes]
    A --> AE[task.clock]
    A --> AF[task.vdp.cursor]
    A --> AG[task.oneshot]
```

## File load and editor reset path

```mermaid
flowchart TD
    A[fm.loadfile] --> B[tv.reset]
    A --> C[pane.colorscheme.load]
    A --> D[fh.file.read.edb]
    D --> E[fm.loadsave.cb.indicator1]
    D --> F[fm.loadsave.cb.indicator2]
    D --> G[fm.loadsave.cb.indicator3]
    D --> H[fm.loadsave.cb.fioerr]
    D --> I[fm.load.cb.memfull]

    A --> J[edb.clear.sams]
    J --> K[edb.line.copy]
    J --> L[edb.block.reset]

    D --> M[edb.find.init]
    D --> N[edb.find.search]
```

## Dialog and command-buffer flow

```mermaid
flowchart TD
    A[dialog] --> B[dialog.main]
    B --> C[dialog.file]
    B --> D[dialog.help]
    B --> E[dialog.opt]
    B --> F[dialog.find]

    G[edk.act.cmdb.char] --> H[cmdb.cmd.clear]
    G --> I[cmdb.cmd.set]
    G --> J[cmdb.cfg.fname]
    G --> K[cmdb.refresh_prompt]

    L[edk.act.cmdb.file.run] --> M[fm.run.ea5]
    L --> N[fm.directory]
    L --> O[fm.browse.fname.next]
    L --> P[fm.browse.fname.prev]
    L --> Q[fm.browse.updir]

    R[edk.act.cmdb.save] --> S[fm.savefile]
    T[edk.act.cmdb.load] --> U[fm.loadfile]
    V[edk.act.cmdb.insert] --> W[fm.insertfile]
    X[edk.act.cmdb.file.delete] --> Y[fm.delfile]
```

## Keyboard dispatch detail

```mermaid
flowchart TD
    A[edkey.keyscan.hook] --> B[edkey.key.process]
    B --> C{pane focus?}
    C -->|Framebuffer| D[edkey.key.process.loadmap.editor]
    C -->|Command buffer| E[edkey.key.process.loadmap.cmdb]
    D --> F[edkey.key.check.next]
    E --> F

    F --> G{key matches action map?}
    G -->|yes| H[edkey.key.check.scope]
    G -->|no| I[edkey.key.process.addbuffer]

    H --> J[edkey.key.process.action]
    J --> K[edk.act.left]
    J --> L[edk.act.right]
    J --> M[edk.act.del_char]
    J --> N[edk.act.block.mark]
    J --> O[edk.act.cmdb.clear]
    J --> P[edk.act.cmdb.file.run]

    I --> Q[edk.fb.char]
    Q --> R[fb.refresh]
```

## Memory / low-level bridge layer

```mermaid
flowchart TD
    A[rom.farjump] --> B[mem.sams.setup.stevie]
    B --> C[mem.sams.set.legacy]
    B --> D[mem.sams.set.boot]
    B --> E[mem.sams.set.stevie]

    F[cpu.crash.showbank] --> G[cpu.crash.showbank.bankstr]
    H[stevie.80x30] --> I[data.vdpmodes]

    J[tib.run] --> K[tib.session.isr]
    J --> L[tib.uncrunch]
    L --> M[tib.uncrunch.prg]
    L --> N[tib.uncrunch.token]
``` 

## Dependency interpretation

The graph shows three major layers:

1. Startup layer: `main.stevie` sets up VDP, SAMS, screen state, task scheduler, and the keyboard hook.
2. Editor action layer: `edkey.key.process` dispatches to `edk.act.*` and `edk.fb.*` routines for movement, editing, blocks, and command actions.
3. Service layer: `fm.*`, `dialog.*`, `pane.*`, and `tib.*` routines build the higher-level editor features on top of low-level SAMS/VDP and bank-switch support.

This is intentionally a dependency overview rather than a complete call tree. The assembler code uses many inline `bl @label` calls and several callback-based flows, so the real graph is more dense than the simplified diagram above.
