require 'active_record'
require 'active_support'
require 'action_view'
require 'sortabl'
require 'spec_helper'
require 'pry'

describe Sortabl do

  before(:all) do
    @connection = ActiveRecord::Base.establish_connection :adapter => 'sqlite3', database: ':memory:'
    CreateSortablRecords.setup
    CreateSortablRecords.seed
  end


  it 'has a version number' do
    expect(Sortabl::VERSION).not_to be nil
  end


  context "if sort_by param is missing, it " do
    it "should raise argument error exception" do
      expect{SortablRecord.all.sortabl}.to raise_error(ArgumentError)
    end
  end


  context "if sort_by params is given, it " do
    it "should fallback to primary key, when attribute not exists" do
      expect(SortablRecord.all.sortabl(:not_given).to_a).to eq(SortablRecord.all.order(id: :asc).to_a)
    end

    it "should fallback to default key, when attribute not exists and default param is given" do
      expect(SortablRecord.all.sortabl(:not_given, default: [some_number: :desc]).to_a).to eq(SortablRecord.all.order(some_number: :desc).to_a)
    end

    it "should sort strings asc" do
      expect(SortablRecord.all.sortabl(:some_string_asc).to_a).to eq(SortablRecord.all.order(some_string: :asc).to_a)
    end

    it "should sort strings desc" do
      expect(SortablRecord.all.sortabl(:some_string_desc).to_a).to eq(SortablRecord.all.order(some_string: :desc).to_a)
    end

    it "should sort number asc" do
      expect(SortablRecord.all.sortabl(:some_number_asc).to_a).to eq(SortablRecord.all.order(some_number: :asc).to_a)
    end

    it "should sort number desc" do
      expect(SortablRecord.all.sortabl(:some_number_desc).to_a).to eq(SortablRecord.all.order(some_number: :desc).to_a)
    end

    it "should sort datetime asc" do
      expect(SortablRecord.all.sortabl(:some_date_asc).to_a).to eq(SortablRecord.all.order(some_date: :asc).to_a)
    end

    it "should sort datetime desc" do
      expect(SortablRecord.all.sortabl(:some_date_desc).to_a).to eq(SortablRecord.all.order(some_date: :desc).to_a)
    end

    it "should sort boolean asc" do
      expect(SortablRecord.all.sortabl(:some_boolean_asc).to_a).to eq(SortablRecord.all.order(some_boolean: :asc).to_a)
    end

    it "should sort boolean desc" do
      expect(SortablRecord.all.sortabl(:some_boolean_desc).to_a).to eq(SortablRecord.all.order(some_boolean: :desc).to_a)
    end
  end


  context "if sort_by and only params is given, it " do
    it "should sort by only included param" do
      expect(SortablRecord.all.sortabl(:some_number_asc, only: [:some_number]).to_a).to eq(SortablRecord.all.order(some_number: :asc).to_a)
    end

    it "should fallback to primary key, when attribute not exists" do
      expect(SortablRecord.all.sortabl(:some_string_asc, only: [:not_given]).to_a).to eq(SortablRecord.all.order(id: :asc).to_a)
    end

    it "should fallback to default key, when attribute not exists and default param is given" do
      expect(SortablRecord.all.sortabl(:some_string_asc, only: [:not_given], default: [some_number: :desc]).to_a).to eq(SortablRecord.all.order(some_number: :desc).to_a)
    end

    it "should fallback to primary key, when attribute exists but not included in only" do
      expect(SortablRecord.all.sortabl(:some_string_asc, only: [:some_number]).to_a).to eq(SortablRecord.all.order(id: :asc).to_a)
    end

    it "should fallback to default key, when attribute exists but not included in only and default is given" do
      expect(SortablRecord.all.sortabl(:some_string_asc, only: [:some_number], default: [some_number: :desc]).to_a).to eq(SortablRecord.all.order(some_number: :desc).to_a)
    end
  end


  context "if sort_by and except params is given, it " do
    it "should sort by not excepted param" do
      expect(SortablRecord.all.sortabl(:some_number_asc, except: [:some_string]).to_a).to eq(SortablRecord.all.order(some_number: :asc).to_a)
    end

    it "should fallback to primary key, when attribute exists but included in except" do
      expect(SortablRecord.all.sortabl(:some_string_asc, except: [:some_string]).to_a).to eq(SortablRecord.all.order(id: :asc).to_a)
    end

    it "should fallback to default key, when attribute exists but included in except and default param is given" do
      expect(SortablRecord.all.sortabl(:some_string_asc, except: [:some_string], default: [some_number: :desc]).to_a).to eq(SortablRecord.all.order(some_number: :desc).to_a)
    end
  end


  context "if sort_by, only and except params is given, it " do
    it "should raise invalid parameters exception" do
      expect{SortablRecord.all.sortabl(:some_string_asc, only: [:some_number], except: [:some_date])}.to raise_error(ArgumentError)
    end
  end

end


class SortablRecord < ActiveRecord::Base
end

class CreateSortablRecords < ActiveRecord::Migration
  def self.setup
    create_table :sortabl_records do |t|
      t.string    :some_string, unique: true
      t.integer   :some_number, unique: true
      t.datetime  :some_date, unique: true
      t.boolean   :some_boolean, unique: true
    end
  end

  def self.seed
    SortablRecord.create!(some_string: 'Alice',    some_number: 45, some_date: Time.now + 5.hour, some_boolean: true)
    SortablRecord.create!(some_string: 'Chester',  some_number: 51, some_date: Time.now - 3.hour, some_boolean: false)
    SortablRecord.create!(some_string: 'Nina',     some_number: 34, some_date: Time.now + 7.hour, some_boolean: true)
    SortablRecord.create!(some_string: 'John',     some_number: 67, some_date: Time.now - 2.hour, some_boolean: false)
    SortablRecord.create!(some_string: 'Marvin',   some_number: 23, some_date: Time.now - 8.hour, some_boolean: false)
    SortablRecord.create!(some_string: 'Peter',    some_number: 17, some_date: Time.now + 4.hour, some_boolean: true)
    SortablRecord.create!(some_string: 'Roy',      some_number: 57, some_date: Time.now + 9.hour, some_boolean: true)
    SortablRecord.create!(some_string: 'Danielle', some_number: 86, some_date: Time.now - 6.hour, some_boolean: false)
  end
end
