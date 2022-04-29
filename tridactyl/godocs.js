const OpenSource = [
  "github.com",
  "gitlab.com",
  "go.pkg.in",
  "go.uber.org"
];

(term => {
  if (term.startsWith("code.uber.internal")) {
    window.location.href = `https://engdocs.uberinternal.com/api/go/pkg/${term}`;
    return
  }

  if (OpenSource.some(site => term.startsWith(site))) {
    window.location.href = `https://pkg.go.dev/${term}`;
    return
  }

  window.location.href = `https://pkg.go.dev/search?q=${term}`;
})(JS_ARG)
