import {
  Denops,
  ensureString,
  op,
  fn
} from './deps.ts'

export async function main (denops: Denops): Promise <void> {

  denops.dispatcher = {
    async encodeURIComponent (text: unknown): Promise <unknown>
    {
      ensureString (text)
      return encodeURIComponent (text)
    },
    async selectedText (): Promise <unknown>
    {
      // あおいえお
      const [, line_start, col_start] = await fn.getpos (denops, "'<")
      const [, line_end,   col_end  ] = await fn.getpos (denops, "'>")
      const lines = await fn.getline (denops, line_start, line_end)
      if (lines.length === 0)
      {
        return ''
      }
      const selection = await op.selection.get (denops)
      lines[lines.length - 1] = lines[lines.length - 1].slice (0, col_end - (selection === 'inclusive' ? 0 : 1))
      lines[0] = lines[0].slice (col_start - 1)
      return lines.join ('\n')
    },
  }

  denops.cmd (`command! -bar DenopsServerRestart call denops#server#stop () | sleep 1 | call denops#server#start ()`)
  denops.cmd (`command! -bar DenopsServerStatus echo denops#server#status ()`)
}
