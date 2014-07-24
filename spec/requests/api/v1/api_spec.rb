require 'spec_helper'

describe "Bar API v1" do

  before {
    @bar = FactoryGirl.create(:bar)
    FactoryGirl.create_list(:bar_special, 4, bar_id: @bar.id)
  }

  it 'sends a given bar' do    
    get "/api/v1/bars/#{@bar.id}"

    expect(response).to be_success
    expect(json['bar'].length).to eq(39)
    expect(json.length).to eq(1)
    expect(json['bar']['name']).to eq(@bar.name)
  end

  it 'sends specials for a given bar' do    
    get "/api/v1/bars/#{@bar.id}/specials"    
    
    expect(response).to be_success
    expect(json[0]['bar_special'].length).to eq(11)
    expect(json.length).to eq(4)
    expect(json[0]['bar_special']['description']).to eq(BarSpecial.first.description)
  end

  it 'sends specials within a given mile' do
    get "/api/v1/specials/near/#{5}/of/#{@bar.zip}"
    
    expect(response).to be_success
    expect(json[0]['bar_special'].length).to eq(13)
    expect(json.length).to eq(4)
    expect(json[0]['bar_special']['description']).to eq(BarSpecial.first.description)
  end
end