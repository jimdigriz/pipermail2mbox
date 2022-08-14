[Pipermail (Mailman 2)](https://www.list.org/) to [Mbox](https://en.wikipedia.org/wiki/Mbox) sync tool.

# Preflight

You will require

 * `curl`
 * `make`

# Usage

Download the mailing list archive with:

    make URL=<URL>

Where `<URL>` is the URL to the index page listing all the history of the mailing list.

Examples:

 * [FreeRADIUS users mailing list](https://lists.freeradius.org/mailman/listinfo/freeradius-users):

       make URL=https://lists.freeradius.org/pipermail/freeradius-users/

 * [Erlang Questions mailing list](https://erlang.org/mailman/listinfo/erlang-questions)

       make URL=https://erlang.org/pipermail/erlang-questions/

   **N.B.** webserver trottles usage so when the downloading stalls, you will need to `Ctrl-C` wait a few minutes and retry

To read the mail, use `mutt` (or `neomutt`, or any other mail client that can read [Mbox format mailboxes](https://en.wikipedia.org/wiki/Mbox)) use:

    mutt -Rf freeradius-users.mbox.gz
