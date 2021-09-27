import { Denops } from 'https://deno.land/x/denops_std/mod.ts'
import { ensureString } from 'https://deno.land/x/unknownutil/mod.ts'

export async function main (denops: Denops): Promise <void> {

  denops.dispatcher = {
    async encodeURIComponent (text: unknown): Promise <unknown>
    {
      ensureString (text)
      return encodeURIComponent (text)
    }
  }

  denops.cmd (`command! -bar DenopsServerRestart call denops#server#restart ()`)
}
