require 'spec_helper'

describe DocxGenerator::Document do
  it "should create a new docx document with the filename specified" do
    document = DocxGenerator::Document.new("word")
    document.filename.should eq("word")
  end
  
  describe "#save" do
    let(:document) { DocxGenerator::Document.new("word") }
  
    after do
      File.delete("word.docx")
    end
  
    it "should save the document" do
      document.save
      File.exists?("word.docx").should be_true
    end
    
    describe "required documents" do
      before { DocxGenerator::Document.new("word").save }
    
      it "should generate a [Content_Types].xml file" do
        Zip::Archive.open("word.docx") do |docx|
          expect { docx.fopen("[Content_Types].xml") }.to_not raise_error
        end
      end
      
      it "should generate a _rels/.rels file" do
        Zip::Archive.open("word.docx") do |docx|
          expect { docx.fopen("_rels/.rels") }.to_not raise_error
        end
      end
      
      it "should generate a word/document.xml" do
        Zip::Archive.open("word.docx") do |docx|
          expect { docx.fopen("word/document.xml") }.to_not raise_error
        end
      end
    end
  end
  
  describe "#add_paragraph" do
    let(:document) { DocxGenerator::Document.new("word") }

    after do
      File.delete("word.docx") if File.exists?("word.docx")
    end
  
    it "should add a paragraph with the fragments supplied separated by a space" do # Space : an option
      document.add_paragraph("The first characters", "and the last ones.").save
      open_file("word/document.xml").should include("<w:p><w:r><w:t>The first characters</w:t></w:r><w:r><w:t xml:space=\"preserve\"> </w:t></w:r><w:r><w:t>and the last ones.</w:t></w:r></w:p>")
    end
    
    # To be modified with bold and italics
    it "should add a paragraph with a formatted text" do
      document.add_paragraph(document.text("The first characters"), "and the last ones.").save
      open_file("word/document.xml").should include("<w:p><w:r><w:t>The first characters</w:t></w:r><w:r><w:t xml:space=\"preserve\"> </w:t></w:r><w:r><w:t>and the last ones.</w:t></w:r></w:p>")
    end
    
    it "should return the current document" do
      document.add_paragraph(["The first characters", "and the last ones."]).should be(document)
    end
  end
  
  describe "#text" do
    it "should return a new Run with text in it" do
      DocxGenerator::Document.new("word").text("Text").to_s.should eq("<w:r><w:t>Text</w:t></w:r>")
    end
    
    context "with styles" do
      it "should return a text in bold" do
        DocxGenerator::Document.new("word").text("Text", bold: true).to_s.should eq("<w:r><w:rPr><w:b w:val=\"true\" /></w:rPr><w:t>Text</w:t></w:r>")
      end
      
      it "should return a text in italics" do
        DocxGenerator::Document.new("word").text("Text", italics: true).to_s.should eq("<w:r><w:rPr><w:i w:val=\"true\" /></w:rPr><w:t>Text</w:t></w:r>")
      end
      
      it "should return an underlined text" do
        DocxGenerator::Document.new("word").text("Text", underline: { style: "single" }).to_s.should eq("<w:r><w:rPr><w:u w:val=\"single\" /></w:rPr><w:t>Text</w:t></w:r>")
      end
    end
  end
end
