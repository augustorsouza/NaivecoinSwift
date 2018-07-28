# Naivecoin: chapter 1
Swift and vapor implementation of the [Naivecoin](https://lhartikk.github.io)

```
vapor build
vapor run
```

##### Get blockchain
```
curl http://localhost:8080/blocks
```

##### Create block
```
curl -H "Content-type:application/json" --data '{"data" : "Some data to the first block"}' http://localhost:8080/mineBlock
``` 

##### Add peer
```
curl -H "Content-type:application/json" --data '{"peer" : "ws://localhost:6001"}' http://localhost:8080/addPeer
```
#### Query connected peers
```
curl http://localhost:8080/peers
```