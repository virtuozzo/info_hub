require 'spec_helper'

describe Filterable do
  let(:klass)   { Todo }
  let(:title_1) { 'Great!' }
  let(:title_2) { 'Awesome!' }
  let(:text_1)  { 'Awesome day!' }
  let(:text_2)  { 'Awesome yesteraday!' }
  let(:todo)    { create :todo, title: title_1, text: text_1, number_id: 7 }
  let(:todo_2)  { create :todo, title: title_2, text: text_2, number_id: 7 }
  let(:todo_3)  { create :todo, title: title_2, text: text_2, number_id: 7 }

  describe '.filter' do
    let(:params) { { 'title' => title_1 } }

    subject(:find) { klass.filter(params) }

    it { is_expected.to be_kind_of klass::ActiveRecord::Relation }

    it { is_expected.to match_array [todo] }

    context 'combine params' do
      let(:params) { { 'title' => title_1, 'text' => text_1 } }

      it { is_expected.to match_array [todo] }
    end

    context 'combine not matched params' do
      let(:params) { { 'title' => title_1, 'text' => text_2 } }

      it { is_expected.to be_empty }
    end

    context 'when 2 records with nilable value ok' do
      let(:params) { { 'title' => title_2, 'text' => text_2, 'number' => nil } }

      it { is_expected.to match_array [todo_2, todo_3] }
    end

    context 'with _id prefix' do
      let(:params) { { 'number_id' => 7 } }

      it { is_expected.to match_array [todo, todo_2, todo_3] }
    end

    context 'throw the error when scope is undefined' do
      let(:params) { { 'faker_id' => 7 } }

      it 'throws undefined method error' do
        expect { find }.to raise_error NoMethodError
      end
    end
  end
end
