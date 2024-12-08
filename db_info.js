// db.auth('alumnodb', passwordPrompt());
//db.auth('alumnodb', 'alumnodb');
print("\nList of collections in database:");
db.getCollectionNames().forEach(function (collection_name) {
    print(collection_name);
}
)
