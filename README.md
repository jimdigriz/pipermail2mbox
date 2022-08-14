[Pipermail (Mailman 2)](https://www.list.org/) to [Mbox](https://en.wikipedia.org/wiki/Mbox) sync tool.

# Preflight

You will require

 * `curl`
 * `make`

# Usage

Download the mailing list archive with:

    make URL=<URL>

Where `<URL>` is the URL to the index page listing all the history of the mailing list.

To update the spool, re-run this command. This will not use much bandwidth as the tool caches the monthly `*.txt.gz` mboxs and will just check the remote server for any updates.

If you wish to download the mailing list in parallel (the example shows using five threads), use:

    make -j5 URL=<URL>

If you wish to use a SOCKS/HTTP proxy server you may do so by setting the environment variable `all_proxy` like so:

    all_proxy=socks5://127.0.0.1:9050 make URL=<URL>

Examples:

 * [FreeRADIUS users mailing list](https://lists.freeradius.org/mailman/listinfo/freeradius-users):

       make URL=https://lists.freeradius.org/pipermail/freeradius-users/

 * [Erlang Questions mailing list](https://erlang.org/mailman/listinfo/erlang-questions)

       make URL=https://erlang.org/pipermail/erlang-questions/

   **N.B.** webserver trottles usage so when the downloading stalls, you will need to `Ctrl-C` wait a few minutes and retry, this is not too bad as (unfortunately) the mailing list is now a readonly non-posting archive so you only need to do this once

Finally, to read the mail, use `mutt` (or `neomutt`, or any other mail client that can read [Mbox format mailboxes](https://en.wikipedia.org/wiki/Mbox)) use:

    mutt -Rf freeradius-users.mbox.gz
