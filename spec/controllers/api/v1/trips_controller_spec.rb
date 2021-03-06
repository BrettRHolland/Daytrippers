require 'rails_helper'

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
end

RSpec.describe Api::V1::TripsController, type: :controller do
  let!(:u1) { User.create(email: 'joe@joe.com', password: 'phillyphilly', display_name: 'joe') }
  let!(:first_trip) { Trip.create(name: 'Liberty Bell', user_id: u1.id, location_id: 3, description: 'Cool trip.') }
  let!(:second_trip) { Trip.create(name: 'Jersey Shore', user_id: u1.id, location_id: 3, description: 'Bad trip.') }
  let!(:review) { FactoryBot.create(:random_review, user: u1, trip: second_trip) }

  describe 'GET#index' do
    it 'should return a list of all trips' do
      get :index
      returned_json = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/json'
      expect(returned_json['trips'][0]['name']).to eq 'Jersey Shore'
    end
  end

  describe 'GET#show' do
    it 'should give more information about selected trip' do
      get :show, params: { id: second_trip.id }
      returned_json = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/json'
      expect(returned_json['trip']['name']).to eq 'Jersey Shore'
    end
  end

  describe 'POST#create' do
    it 'creates a new trip' do
      post_json = {
        trip: {
          name: 'Art Museum',
          description: 'Cool trip.'
        },
        user_id: u1.id
      }

      prev_count = Trip.count
      post(:create, params: post_json)
      expect(Trip.count).to eq(prev_count + 1)
    end

    it 'returns the json of the newly posted trip' do
      post_json = {
        trip: {
          name: 'Art Museum',
          location_id: 3,
          description: 'Cool trip.'
        },
        user_id: u1.id
      }

      post(:create, params: post_json)
      returned_json = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/json'

      expect(returned_json).to be_kind_of(Hash)
      expect(returned_json['trip']['name']).to eq 'Art Museum'
    end
  end
end
