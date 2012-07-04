describe 'ItemView', ->

  before ->
    @itemView = new Backbone.View
      tagName: 'li'
      className: 'item'

  describe "el", ->

    it 'should return a value', ->
      expect(@itemView.el).to.exist

    it "should return an 'li' element", ->
      @itemView.el.tagName.should.equal "LI"

  describe '$el', ->

    it "should have class 'item'", ->
      @itemView.$el.hasClass('item').should.be.true