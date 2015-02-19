require 'spec_helper'

describe SlackMessages::SlackIssueMessage do
  subject { SlackMessages::SlackIssueMessage.new(args) }

  let(:args) {
    {
      user: {
        username: 'username'
      },
      project_name: 'project_name',
      project_url: 'somewhere.com',

      object_attributes: {
        title: 'Issue title',
        id: 10,
        iid: 100,
        assignee_id: 1,
        url: 'url',
        action: 'open',
        state: 'opened',
        description: 'issue description'
      }
    }
  }

  let(:color) { '#345' }

  context 'open' do
    it 'returns a message regarding opening of issues' do
      expect(subject.pretext).to eq(
        'username opened issue <url|#100> in <somewhere.com|project_name>: '\
        'Issue title')
      expect(subject.attachments).to eq([
        {
          text: "issue description",
          color: color,
        }
      ])
    end
  end

  context 'close' do
    before do
      args[:object_attributes][:action] = 'close'
      args[:object_attributes][:state] = 'closed'
    end
    it 'returns a message regarding closing of issues' do
      expect(subject.pretext). to eq(
        'username closed issue <url|#100> in <somewhere.com|project_name>: '\
        'Issue title')
      expect(subject.attachments).to be_empty
    end
  end
end
