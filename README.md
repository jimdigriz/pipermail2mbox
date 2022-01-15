[Mailman 2](https://www.list.org/) to [Mbox](https://en.wikipedia.org/wiki/Mbox) sync tool.

# Preflight

You will require

 * `curl`
 * `make`

# Usage

Download the mailing list archive with:

    make URL=<URL>

Where `<URL>` is the URL to the index page listing all the history of the mailing list.

Examples:

 * [FreeRADIUS users mailing list](http://lists.freeradius.org/mailman/listinfo/freeradius-users):

       make URL=http://lists.freeradius.org/pipermail/freeradius-users/

 * [Erlang Questions mailing list](https://erlang.org/mailman/listinfo/erlang-questions)

       make URL=https://erlang.org/pipermail/erlang-questions/

To read the mail, use `mutt` (or `neomutt`, or any other mail client that can read [Mbox format mailboxes](https://en.wikipedia.org/wiki/Mbox)) use:

    mutt -Rf mbox/freeradius-users.mbox.gz
