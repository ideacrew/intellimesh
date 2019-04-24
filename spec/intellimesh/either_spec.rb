require "spec_helper"

RSpec.describe Intellimesh::Either, "given a 'right' value" do
  let(:right_value) { 1 }

  subject { Intellimesh::Either.right(right_value) }

  it "is not left" do
    expect(subject.left?).to be_falsey
  end

  it "is right" do
    expect(subject.right?).to be_truthy
  end

  it "propagates block operations on the value" do
    new_either = subject.fmap { |a| a + 1 }
    expect(new_either.value).to eq 2
  end

  it "propagates block operations returning a correct result" do
    new_either = subject.then { |a| Intellimesh::Either.right(a + 1) }
    expect(new_either.value).to eq 2
  end

  it "is subsumed by block operations returning an error result" do
    new_either = subject.then { |a| Intellimesh::Either.left("some error") }
    expect(new_either.left?).to be_truthy
  end
end

RSpec.describe Intellimesh::Either, "given a 'left' value" do
  let(:left_value) { "some error" }

  subject { Intellimesh::Either.left(left_value) }

  it "is left" do
    expect(subject.left?).to be_truthy
  end

  it "is not right" do
    expect(subject.right?).to be_falsey
  end

  it "ignores block operations on the value and keeps the original error" do
    new_either = subject.fmap { |a| a + 1 }
    expect(new_either.value).to eq left_value
  end

  it "ignores block operations returning a correct result" do
    new_either = subject.then { |a| Intellimesh::Either.right(a + 1) }
    expect(new_either.value).to eq left_value
  end

  it "subsumes block operations returning an error result" do
    new_either = subject.then { |a| Intellimesh::Either.left("some error other error") }
    expect(new_either.value).to eq left_value
  end
end