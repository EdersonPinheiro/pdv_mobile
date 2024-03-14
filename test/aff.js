Parse.Cloud.define("get-all-products", async (request) => {
    if (request.user == null) throw "Usuário não autenticado";
    const query = new Parse.Query(Product);
    query.descending("createdAt");
    const queryS = new Parse.Query(User);
    console.log(request.user.id);
    queryS.include("setor");
    const setorResult = await Parse.Cloud.run("get-setor-id", {}, { sessionToken: request.user.getSessionToken() });
    const setor = setorResult[0].id;
    console.log("Setor ${setor}");
    console.log(setor);
    queryS.equalTo("setor", { __type: "Pointer", className: "Setor", objectId: setor });
    const user = await queryS.find();

    const ids = user.map(function (o) {
        o = o.toJSON();
        return o.setor.objectId;
    });

    query.containedIn("setor", ids);

    const product = await query.find({ useMasterKey: true });

    return product.map(function (p) {
        p = p.toJSON();
        return formatProduct(p);
    });
});

function formatProduct(productJson) {
    return {
        id: productJson.objectId,
        name: productJson.name,
        description: productJson.description,
        setor: productJson.setor.objectId,
        group: productJson.group.objectId,
        quantity: productJson.quantity,
        action: productJson.action
    }
}

module.exports = { formatProduct };