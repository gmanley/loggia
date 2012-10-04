collection @albums
extends 'albums/_album'
node(:children) {|album| partial('albums/_album', object: album.children) }
