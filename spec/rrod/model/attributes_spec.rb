require 'spec_helper'
require 'support/models/car'

describe Rrod::Model do

  let(:model) { Car }
  let(:hash)  { {wheels: 4, color: :black, make: 'Jeep'} }
  let(:instance) { model.new(hash) }

  describe "instantiation" do
    it "can create an object with an arbitrary hash" do
      expect(instance.wheels).to eq 4
      expect(instance.color).to eq :black
      expect(instance.make).to eq 'Jeep'
    end

    it "always has an id property" do
      expect(instance).to respond_to :id
      expect(instance.id).to be_nil
    end

    it "does not re-define an attribute for :id" do
      instance = model.new(id: 'Dogs are silly!')
      included_module = instance.send(:attribute_methods, instance.attributes)
      expect(Class.new{extend included_module}).not_to respond_to :id 
    end

    it "manages attribute keys as strings" do
      expect(instance.attributes).to eq hash.stringify_keys
    end

    it "ignores modifications to the attribute hash" do
      instance.attributes[:model] = 'Wrangler'
      expect(instance.attributes[:model]).to be_nil
    end

    it "will return nil for an attribute that exists in the hash but does not have a corresponding method" do
      instance.instance_variable_get(:@attributes)['foo'] = 'bar'
      expect(instance).not_to respond_to(:foo)
      expect(instance.attributes).to include('foo' => nil)
    end

    describe "mass assignment" do
      it "will merge attributes when mass assigning" do
        instance.attributes = {wheels: 5}
        expect(instance.wheels).to eq 5
      end

      it "will not add additional attribute methods after instantiation" do
        expect { instance.attributes = {model: 'Wrangler'} }.to raise_error
      end
    end

  end
end
