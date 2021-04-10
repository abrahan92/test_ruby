require 'spec_helper'
require_relative '../order_report'

describe 'Order API', type: :request do

  response = process_data(true)

  it 'response correct structure' do
    expect(response.keys).to contain_exactly(:data, :status_code)
  end

  it 'response must be an object' do
    expect(response).to be_a(Hash) 
  end

  it 'status code must be success (200)' do
    expect(response[:status_code]).to eq(200)
  end
  
  # Orders count
  describe 'orders_count' do
    it 'must be an integer number' do
      expect(response[:data][:orders_count]).to be_a(Integer) 
    end

    it 'should not be nil' do
      expect(response[:data][:orders_count]).not_to be(NIL)
    end
  end

  # Most popular
  describe 'most_popular' do
    it 'must be a string' do
      expect(response[:data][:most_popular]).to be_a(String) 
    end
  end

  # Least popular
  describe 'least_popular' do
    it 'must be a string' do
      expect(response[:data][:least_popular]).to be_a(String) 
    end
  end

  # Median order value
  describe 'median_order_value' do
    it 'must be a float' do
      expect(response[:data][:median_order_value]).to be_a(Float) 
    end
  end

  # Product repurchased interval
  describe 'product_repurchased_interval' do
    it 'must be a string' do
      expect(response[:data][:product_repurchased_interval]).to be_a(String) 
    end
  end

  # Page number
  describe 'page_number' do
    it 'must be a string' do
      expect(response[:data][:page_number]).to be_a(String) 
    end
  end
end