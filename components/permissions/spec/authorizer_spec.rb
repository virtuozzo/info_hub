require 'spec_helper'

describe Permissions::Authorizer do
  let(:user) { new_user }
  let(:action) { :read }
  let(:options) { {} }

  describe '.authorized_class?' do
    subject { described_class.authorized_class?(klass, user, action, options) }
    let(:klass) { user_class }

    context 'user has permission' do
      before { allow(user).to receive(:has_permission?).with(klass, action, options) { true } }

      it { is_expected.to be_truthy }
    end

    context 'user does not have permission' do
      before { allow(user).to receive(:has_permission?).with(klass, action, options) { false } }

      it { is_expected.to be_falsey }
    end
  end

  describe '.authorized_object?' do
    subject { described_class.authorized_object?(object, user, action) }

    context 'with supplied resources' do
      let(:object) { new_user supplied: true }
      let(:action) { :action }

      it { is_expected.to be_falsey }
    end

    context 'for any class' do
      let(:object) { new_image_template user: user }

      context ':all scope' do
        before { allow(object.class).to receive(:authorized_for?).with(user, action, scope: :all) { true } }

        it { is_expected.to be_truthy }
      end

      context ':own scope' do
        before do
          allow(object.class).to receive(:authorized_for?).exactly(1) { false }
          allow(object.class).to receive(:authorized_for?).with(user, action, scope: :own) { true }
        end

        it { is_expected.to be_truthy }
      end

      context ':user scope' do
        let(:object) { new_image_template user: nil }

        before do
          allow(object.class).to receive(:authorized_for?).exactly(2) { false }
          allow(object.class).to receive(:authorized_for?).with(user, action, scope: :public) { true }
        end

        it { is_expected.to be_truthy }
      end

      context ':own scope' do
        before do
          allow(object.class).to receive(:authorized_for?).exactly(3) { false }
          allow(object.class).to receive(:authorized_for?).with(user, action, scope: :user) { true }
        end

        it { is_expected.to be_truthy }
      end

      context 'user is not authorized' do
        before do
          allow(object.class).to receive(:authorized_for?).exactly(4) { false }
        end

        it { is_expected.to be_falsey }
      end
    end
  end
end
