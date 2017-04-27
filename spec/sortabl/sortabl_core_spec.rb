require 'active_record'
require 'active_support'
require 'action_view'
require 'spec_helper'
require 'pry'

describe Sortabl do

  before(:all) do
    @connection = ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
    ExampleData.setup
    ExampleData.seed
  end

  it 'has a version number' do
    expect(Sortabl::VERSION).not_to be nil
  end


  context "if param is missing, it " do
    it "should raise argument error exception" do
      expect{Address.all.sortabl}.to raise_error(ArgumentError)
    end
  end


  context "if param is given, it " do
    it "should fallback to primary key, when attribute not exists" do
      expect(Address.all.sortabl(:not_given).to_a).to eq(Address.all.order(id: :asc).to_a)
    end

    it "should fallback to default key, when attribute not exists and default param is given" do
      expect(Address.all.sortabl(:not_given, default: [number: :desc]).to_a).to eq(Address.all.order(number: :desc).to_a)
    end

    it "should sort strings asc" do
      expect(Address.all.sortabl(:street_asc).to_a).to eq(Address.all.order(street: :asc).to_a)
    end

    it "should sort strings desc" do
      expect(Address.all.sortabl(:street_desc).to_a).to eq(Address.all.order(street: :desc).to_a)
    end

    it "should sort number asc" do
      expect(Address.all.sortabl(:number_asc).to_a).to eq(Address.all.order(number: :asc).to_a)
    end

    it "should sort number desc" do
      expect(Address.all.sortabl(:number_desc).to_a).to eq(Address.all.order(number: :desc).to_a)
    end

    it "should sort datetime asc" do
      expect(Address.all.sortabl(:since_asc).to_a).to eq(Address.all.order(since: :asc).to_a)
    end

    it "should sort datetime desc" do
      expect(Address.all.sortabl(:since_desc).to_a).to eq(Address.all.order(since: :desc).to_a)
    end

    it "should sort boolean asc" do
      expect(Address.all.sortabl(:main_asc).to_a).to eq(Address.all.order(main: :asc).to_a)
    end

    it "should sort boolean desc" do
      expect(Address.all.sortabl(:main_desc).to_a).to eq(Address.all.order(main: :desc).to_a)
    end
  end


  context "if alias param is given, it " do
    it "should sort strings asc" do
      expect(Address.all.sortabl(:street_name_asc).to_a).to eq(Address.all.order(street: :asc).to_a)
    end

    it "should sort strings desc" do
      expect(Address.all.sortabl(:street_name_desc).to_a).to eq(Address.all.order(street: :desc).to_a)
    end

    it "should sort number asc" do
      expect(Address.all.sortabl(:house_number_asc).to_a).to eq(Address.all.order(number: :asc).to_a)
    end

    it "should sort number desc" do
      expect(Address.all.sortabl(:house_number_desc).to_a).to eq(Address.all.order(number: :desc).to_a)
    end

    it "should sort datetime asc" do
      expect(Address.all.sortabl(:moved_in_since_asc).to_a).to eq(Address.all.order(since: :asc).to_a)
    end

    it "should sort datetime desc" do
      expect(Address.all.sortabl(:moved_in_since_desc).to_a).to eq(Address.all.order(since: :desc).to_a)
    end

    it "should sort boolean asc" do
      expect(Address.all.sortabl(:main_appartment_asc).to_a).to eq(Address.all.order(main: :asc).to_a)
    end

    it "should sort boolean desc" do
      expect(Address.all.sortabl(:main_appartment_desc).to_a).to eq(Address.all.order(main: :desc).to_a)
    end
  end


  context "if param and only option is given, it " do
    it "should sort by only included param" do
      expect(Address.all.sortabl(:number_asc, only: [:number]).to_a).to eq(Address.all.order(number: :asc).to_a)
    end

    it "should fallback to primary key, when attribute not exists" do
      expect(Address.all.sortabl(:street_asc, only: [:not_given]).to_a).to eq(Address.all.order(id: :asc).to_a)
    end

    it "should fallback to default key, when attribute not exists and default param is given" do
      expect(Address.all.sortabl(:street_asc, only: [:not_given], default: [number: :desc]).to_a).to eq(Address.all.order(number: :desc).to_a)
    end

    it "should fallback to primary key, when attribute exists but not included in only" do
      expect(Address.all.sortabl(:street_asc, only: [:number]).to_a).to eq(Address.all.order(id: :asc).to_a)
    end

    it "should fallback to default key, when attribute exists but not included in only and default is given" do
      expect(Address.all.sortabl(:street_asc, only: [:number], default: [number: :desc]).to_a).to eq(Address.all.order(number: :desc).to_a)
    end
  end


  context "if param and except option is given, it " do
    it "should sort by not excepted param" do
      expect(Address.all.sortabl(:number_asc, except: [:street]).to_a).to eq(Address.all.order(number: :asc).to_a)
    end

    it "should fallback to primary key, when attribute exists but included in except" do
      expect(Address.all.sortabl(:street_asc, except: [:street]).to_a).to eq(Address.all.order(id: :asc).to_a)
    end

    it "should fallback to default key, when attribute exists but included in except and default param is given" do
      expect(Address.all.sortabl(:street_asc, except: [:street], default: [number: :desc]).to_a).to eq(Address.all.order(number: :desc).to_a)
    end
  end


  context "if param, only and except option is given, it " do
    it "should raise invalid parameters exception" do
      expect{Address.all.sortabl(:street_asc, only: [:number], except: [:since])}.to raise_error(ArgumentError)
    end
  end


  context "if associated param is given, it ", focus: true do
    it "should sort strings asc" do
      expect(Address.includes(:person).all.sortabl('people.name_asc').to_a).to eq(Address.includes(:person).all.order("people.name asc").to_a)
    end

    it "should sort strings desc" do
      expect(Address.includes(:person).all.sortabl('people.name_desc').to_a).to eq(Address.includes(:person).all.order("people.name desc").to_a)
    end

    it "should sort number asc" do
      expect(Address.includes(:person).all.sortabl('people.height_asc').to_a).to eq(Address.includes(:person).all.order("people.height asc").to_a)
    end

    it "should sort number desc" do
      expect(Address.includes(:person).all.sortabl('people.height_desc').to_a).to eq(Address.includes(:person).all.order("people.height desc").to_a)
    end

    it "should sort datetime asc" do
      expect(Address.includes(:person).all.sortabl('people.birthday_asc').to_a).to eq(Address.includes(:person).all.order("people.birthday asc").to_a)
    end

    it "should sort datetime desc" do
      expect(Address.includes(:person).all.sortabl('people.birthday_desc').to_a).to eq(Address.includes(:person).all.order("people.birthday desc").to_a)
    end

    it "should sort boolean asc" do
      expect(Address.includes(:person).all.sortabl('people.married_asc').to_a).to eq(Address.includes(:person).all.order("people.married asc").to_a)
    end

    it "should sort boolean desc" do
      expect(Address.includes(:person).all.sortabl('people.married_desc').to_a).to eq(Address.includes(:person).all.order("people.married desc").to_a)
    end
  end

end


class Address < ActiveRecord::Base
  # Alias attributes
  alias_attribute :street_name, :street
  alias_attribute :house_number, :number
  alias_attribute :moved_in_since, :since
  alias_attribute :main_appartment, :main

  # Relations
  belongs_to :person
end

class Person < ActiveRecord::Base
  # Relations
  has_many :addresses
end

class ExampleData < ActiveRecord::Migration
  def self.setup
    create_table :addresses do |t|
      t.references  :person, null: false, foreign_key: true
      t.string      :street, unique: true
      t.integer     :number, unique: true
      t.datetime    :since, unique: true
      t.boolean     :main
    end

    create_table :people do |t|
      t.string    :name, unique: true
      t.integer   :height, unique: true
      t.datetime  :birthday, unique: true
      t.boolean   :married
    end
  end

  def self.seed
    Person.create!([
      { id: 1, name: 'Oliver',  height: 178, birthday: '1978-06-09', married: true },
      { id: 2, name: 'Alice',   height: 165, birthday: '1962-08-10', married: true },
      { id: 3, name: 'Enrique', height: 182, birthday: '1951-04-23', married: false },
      { id: 4, name: 'Kathryn', height: 172, birthday: '1986-02-17', married: false }
    ])

    Address.create!([
      { person_id: 1, street: 'Parker Rd',     number: 2398, since: '1982-07-29', main: false },
      { person_id: 2, street: 'Seventh St',    number: 1636, since: '1979-10-01', main: false },
      { person_id: 2, street: 'E-Pecan St',    number: 2984, since: '1989-04-17', main: false },
      { person_id: 2, street: 'Hamilton Ave',  number: 6209, since: '1992-02-23', main: true },
      { person_id: 1, street: 'Elisworth Ave', number: 1413, since: '1989-05-03', main: true },
      { person_id: 3, street: 'Texas Ave',     number: 2370, since: '1965-02-20', main: false },
      { person_id: 3, street: 'Lakeshore Rd',  number: 5162, since: '1984-03-21', main: false },
      { person_id: 3, street: 'Mckinley Ave',  number: 7845, since: '1986-12-15', main: true },
      { person_id: 4, street: 'Edwards Rd',    number: 1151, since: '1987-08-15', main: false },
      { person_id: 4, street: 'Mcclellan Rd',  number: 5836, since: '1989-10-08', main: true }
    ])
  end
end
