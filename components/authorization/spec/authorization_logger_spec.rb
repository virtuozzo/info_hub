require 'spec_helper'

describe SpecController, type: :controller do
  before { Rails.configuration.authorization_debug = true }

  describe '#default_authorized?' do
    let(:logger)  { Rails.logger }
    let(:user)    { create :user }
    let(:action)  { :create }
    let(:aliases) { { index: :read, show: :read, new: :create,
                      create: :create, edit: :update, update: :update,
                      destroy: :delete } }

    before { sign_in user }

    context 'instace' do
      context 'has permission' do
        it 'writes logs and performs action' do
          expect(logger).to receive(:debug).with("Authorization. resource: #{user.inspect}")
          expect(logger).to receive(:debug).with("Authorization. action: #{action}")
          expect(logger).to receive(:debug).with("Authorization. mapping: #{aliases.with_indifferent_access.inspect}")
          expect(logger).to receive(:debug).with("Authorization. @resource_action: #{action}")

          get :authorized

          expect(response).to have_http_status :success
          expect(response.body).to eq 'Success!'
        end
      end

      context 'has no permission', retry: 3 do
        let(:action) { :edit }

        it 'writes specific logs and does not perform action' do
          allow(logger).to receive(:warn).with("Was used unknown action `edit` for `users`")

          expect(logger).to receive(:debug).with("Authorization. resource: #{user.inspect}")
          expect(logger).to receive(:debug).with("Authorization. action: #{action}")
          expect(logger).to receive(:debug).with("Authorization. mapping: #{aliases.with_indifferent_access.inspect}")
          expect(logger).to receive(:debug).with("Authorization. @resource_action: #{action}")
          expect(logger).to receive(:debug).with("Authorization. User permissions: #{user.permission_identifiers.inspect}")
          expect(logger).to receive(:debug).with('Authorization. User not authorized!')
          expect(logger).to receive(:warn).with("Authorization. Required permission is \e[31musers.edit\e[0m")

          get :unauthorized

          expect(response).not_to have_http_status :success
        end
      end
    end

    context 'class' do
      context 'has permission' do
        it 'writes logs and performs action' do
          expect(logger).to receive(:debug).with("Authorization. resource: #{User.inspect}")
          expect(logger).to receive(:debug).with("Authorization. action: #{action}")
          expect(logger).to receive(:debug).with("Authorization. mapping: #{aliases.with_indifferent_access.inspect}")
          expect(logger).to receive(:debug).with("Authorization. @resource_action: #{action}")

          get :class_authorized

          expect(response).to have_http_status :success
          expect(response.body).to eq 'Success!'
        end
      end
    end

    context 'has no permission' do
      let(:action) { :edit }

      it 'writes specific logs and does not perform action' do
        allow(logger).to receive(:warn).with("Was used unknown action `edit` for `users`")

        expect(logger).to receive(:debug).with("Authorization. resource: #{User.inspect}")
        expect(logger).to receive(:debug).with("Authorization. action: #{action}")
        expect(logger).to receive(:debug).with("Authorization. mapping: #{aliases.with_indifferent_access.inspect}")
        expect(logger).to receive(:debug).with("Authorization. @resource_action: #{action}")
        expect(logger).to receive(:debug).with("Authorization. User permissions: #{user.permission_identifiers.inspect}")
        expect(logger).to receive(:debug).with('Authorization. User not authorized!')
        expect(logger).to receive(:warn).with("Authorization. Required permission is \e[31musers.edit\e[0m")

        get :class_unauthorized

        expect(response).not_to have_http_status :success
      end
    end
  end
end
