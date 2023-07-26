require 'rails_helper'

RSpec.describe SearchService do
  it 'calls search for All resources' do
    expect(ThinkingSphinx).to receive(:search).with(ThinkingSphinx::Query.escape('query'))
    SearchService.new('All', 'query').call
  end

  it 'calls search for all others resources' do
    %w[Question Answer Comment User].each do |resource|
      expect(resource.constantize).to receive(:search).with(ThinkingSphinx::Query.escape('query'))
      SearchService.new(resource, 'query').call
    end
  end
end
