object @album
extends 'albums/_album'
node(:children) { partial('albums/_album', object: @children) }
node(:images) { partial('images/_image', object: @images) }
