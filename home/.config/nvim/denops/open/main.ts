import {
  Denops,
  ensureString, ensureArray, ensureNumber,
  fn
} from '../util/deps.ts'

async function which (command: string): Promise<Boolean>
{
  const subprocess = Deno.run ({
    cmd: ['which', command],
    stdin: 'null',
    stdout: 'null',
    stderr: 'null',
  })
  const status = await subprocess.status ()
  return status.success
}

const open_command = (async () => {
  if (await which ('powershell.exe'))
  {
    return (... args: string[]) => Deno.run ({
      cmd: ['powershell.exe', 'start', ... args],
      stdin: 'null',
      stdout: 'piped',
      stderr: 'piped',
    })
  }
  else if (await which ('open'))
  {
    return (... args: string[]) => Deno.run ({
      cmd: ['open', ... args],
      stdin: 'null',
      stdout: 'piped',
      stderr: 'piped',
    })
  }
  else if (await which ('xdg-open'))
  {
    return (... args: string[]) => Deno.run ({
      cmd: ['xdg-open', ... args],
      stdin: 'null',
      stdout: 'piped',
      stderr: 'piped',
    })
  }
  else
  {
    return (... _args: string[]) => { throw new Error ('cannot open') }
  }
}) ()

async function open (... args: string[]) {
  const subprocess = (await open_command) (... args)
  const status = await subprocess.status ()
  const textDecoder = new TextDecoder ()
  if (status.code > 0)
  {
    const output = await subprocess.stderrOutput ()
    const text = textDecoder.decode (output)
    throw new Error (text)
  }
  else
  {
    const output = await subprocess.output ()
    const text = textDecoder.decode (output)
    return text
  }
}

const openURI = (x: string) => open (encodeURI (x))
const openGitHub = (x: string) => openURI (`https://github.com/${x}`)
const openGoogle = (x: string) => open (`https://www.google.com/search?q=${encodeURIComponent (x)}`)
const openGoogleEnglish = (x: string) => open (`https://www.google.com/search?q=${encodeURIComponent (x)}&gl=us&hl=en`)
const openDeepL = (x: string) => open (`https://www.deepl.com/translator#en/ja/${encodeURIComponent (x)}`)
const openTweetIntent = (x: string) => open (`https://twitter.com/intent/tweet?text=${encodeURIComponent (x)}`)

export async function main (denops: Denops): Promise <void> {

  denops.dispatcher = {
    async open (... args: unknown[]): Promise <void>
    {
      ensureArray <string> (args)
      open (... args)
    },
    async openURI (arg: unknown): Promise <void>
    {
      ensureString (arg)
      openURI (arg)
    },
    async openGitHub (arg: unknown): Promise <void>
    {
      ensureString (arg)
      openGitHub (arg)
    },
    async openGoogle (word: unknown, line1_: unknown, line2_: unknown): Promise <void>
    {
      ensureString (word)
      const lastline = await fn.line (denops, '$')
      const line1 = line1_ ?? 1
      const line2 = line2_ ?? lastline
      ensureNumber (line1)
      ensureNumber (line2)

      if (line1 === 1 && line2 === lastline)
      {
        const str = await denops.call ('buffer#last_selected_text') as string
        if (str.split ('\n').length === lastline)
        {
          openGoogle (str)
        }
        else
        {
          openGoogle (word)
        }
      }
      else
      {
        const str = await denops.call ('buffer#last_selected_text') as string
        openGoogle (str)
      }
    },
    async openGoogleEnglish (word: unknown, line1_: unknown, line2_: unknown): Promise <void>
    {
      ensureString (word)
      const lastline = await fn.line (denops, '$')
      const line1 = line1_ ?? 1
      const line2 = line2_ ?? lastline
      ensureNumber (line1)
      ensureNumber (line2)

      if (line1 === 1 && line2 === lastline)
      {
        const str = await denops.call ('buffer#last_selected_text') as string
        if (str.split ('\n').length === lastline)
        {
          openGoogleEnglish (str)
        }
        else
        {
          openGoogleEnglish (word)
        }
      }
      else
      {
        const str = await denops.call ('buffer#last_selected_text') as string
        openGoogleEnglish (str)
      }
    },
    async openDeepL (arg: unknown): Promise <void>
    {
      ensureString (arg)
      openDeepL (arg)
    },
    async openTweetIntent (arg: unknown): Promise <void>
    {
      ensureString (arg)
      openTweetIntent (arg)
    },
  }

  denops.cmd (`command! -bar OpenGitHub call denops#notify ('${denops.name}', 'openGitHub', [expand ('<cfile>')])`)
  denops.cmd (`command! -bar -range=% Google call denops#notify ('${denops.name}', 'openGoogle', [expand ('<cfile>'), <line1>, <line2>])`)
  denops.cmd (`command! -bar -range=% GoogleEng call denops#notify ('${denops.name}', 'openGoogleEnglish', [expand ('<cfile>'), <line1>, <line2>])`)
  denops.cmd (`command! -bar -range=% DeepL call denops#notify ('${denops.name}', 'openDeepL', [join (getline (<line1>, <line2>), "\n")])`)
  denops.cmd (`command! -bar -range=% Tweet call denops#notify ('${denops.name}', 'openTweetIntent', [join (getline (<line1>, <line2>), "\n")])`)
}
