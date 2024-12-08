printjson(db.sample_airbnb.find({bedrooms: {$gt: 2}},{id:1,name:1,bedrooms:1, description:1}))
