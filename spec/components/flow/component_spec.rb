require 'rails_helper'

describe Flow::Component, type: :component do
  let(:component) { described_class.new(value: value, max: max, signal: true) }

  describe '#height_class' do
    subject { component.height_class }

    context 'when 150%' do
      let(:value)     { 1_500          }
      let(:max)       { 1_000          }

      it { is_expected.to eq('h-12') }
    end

    context 'when 100%' do
      let(:value)     { 1_000          }
      let(:max)       { 1_000          }

      it { is_expected.to eq('h-12') }
    end

    context 'when 50%' do
      let(:value)     { 500            }
      let(:max)       { 1_000          }

      it { is_expected.to eq('h-9') }
    end

    context 'when 33%' do
      let(:value)     { 333            }
      let(:max)       { 1_000          }

      it { is_expected.to eq('h-7') }
    end

    context 'when 5%' do
      let(:value)     { 50             }
      let(:max)       { 1_000          }

      it { is_expected.to eq('h-3') }
    end

    context 'when 0%' do
      let(:value)     { 0              }
      let(:max)       { 1_000          }

      it { is_expected.to eq('h-0 border') }
    end
  end
end
