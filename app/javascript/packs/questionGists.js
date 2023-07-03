import { loadGist } from '../utilities/load_gists';

$(document).on('turbolinks:load', function () {
  const gists = $('#question-gists').data('gists');
  const token = $('#question-gists').data('token');
  const targetNode = $('#question-link-list');

  loadGist(gists, token, targetNode);
});
