(async url => {
  let tabs = await browser.tabs.query({});
  let tabIds = tabs.filter(tab => tab.url.includes(url)).map(tab => tab.id);

  let window = await browser.windows.create();

  await browser.tabs.move(
    tabIds,
    { windowId: window.id, index: -1 }
  );

  await browser.tabs.remove(window.tabs[0].id);
})(JS_ARG);
