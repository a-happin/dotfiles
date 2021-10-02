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
  }

  denops.cmd (`command! -bar DenopsServerRestart call denops#server#stop () | sleep 1 | call denops#server#start ()`)
  denops.cmd (`command! -bar DenopsServerStatus echo denops#server#status ()`)
}
