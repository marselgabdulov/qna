shared_examples_for 'Status Successful' do
  it 'returns status successful' do
    expect(response).to be_successful
  end
end
