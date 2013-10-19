require 'spec_helper'

describe "Bar API v2" do

  before {
    @bar = FactoryGirl.create(:bar)
    FactoryGirl.create_list(:bar_special, 4, bar_id: @bar.id)
  }

  it 'sends a given bar' do    
    get "/api/v2/bars/#{@bar.id}"
    json = JSON.parse(response.body)

    expect(response).to be_success
    expect(json.length).to eq(39)
    expect(json['name']).to eq(@bar.name)    
  end

  it 'sends specials for a given bar' do    
    get "/api/v2/bars/#{@bar.id}/specials"    
    json = JSON.parse(response.body)
    
    expect(response).to be_success
    expect(json[0].length).to eq(11)
    expect(json[0]['description']).to eq(BarSpecial.first.description)
    expect(json.length).to eq(4)
  end

  it 'sends specials within a given mile' do
    get "/api/v2/specials/near/#{5}/of/#{@bar.zip}"
    json = JSON.parse(response.body)
    
    expect(response).to be_success
    expect(json[0].length).to eq(13)
    expect(json[0]['description']).to eq(BarSpecial.first.description)
    expect(json.length).to eq(4)
  end
end