import { loadGist } from '../utilities/load_gists';

$(document).on('turbolinks:load', function () {
  const gists = $('#answer-gists').data('gists');
  const token = $('#answer-gists').data('token');
  const targetNode = $('#answer-link-list');

  loadGist(gists, token, targetNode);
});
