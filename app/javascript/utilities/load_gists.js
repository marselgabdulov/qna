const GistClient = require('gist-client');
const gistClient = new GistClient();

export function loadGist(gists, token, targetNode) {
  gistClient.setToken(token);

  gists.forEach((gist) => {
    gistClient
      .getOneById(gist)
      .then((response) => {
        const data = response.files;
        const fileName = Object.keys(data)[0];
        const content = data[fileName].content;
        $(targetNode).append(`<li class="gist">${content}</li>`);
      })
      .catch((err) => {
        console.log(err);
      });
  });
}
