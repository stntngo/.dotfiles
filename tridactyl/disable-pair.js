// Any url listed in the sites array will have tridactyl automatically
// shut off -- set into ignore mode -- when the page is entered and
// tridactyl will be turnd back on upon leaving the site.
const sites = [
  "mail.google.com",
  "docs.google.com",
  "nytimes.com/crosswords/game",
];

const escape = (string) => {
    return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

sites.forEach(site => {
  tri.excmds.autocmd("DocStart", escape(site), "mode ignore");
  tri.excmds.autocmd("TabEnter", escape(site), "mode ignore");
});
