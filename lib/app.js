
Parse.Cloud.define("get-payment-token", async (req) => {
    try {
        EfiJs.CreditCard.debugger(true)
            .setAccount('2789c1f1f14ffaad62df3c48f0d88cc0')
            .setEnvironment('production') // 'production' or 'sandbox'
            .setCreditCardData({
                brand: req.params.brand,
                number: req.params.number,
                cvv: req.params.cvv,
                expirationMonth: req.params.expirationMonth,
                expirationYear: req.params.expirationYear,
                reuse: false
            })
            .getPaymentToken()
            .then(data => {
                const payment_token = data.payment_token;
                const card_mask = data.card_mask;
                console.log('payment_token', payment_token);
                console.log('card_mask', card_mask);
            }).catch(err => {
                console.log('Código: ', err.code);
                console.log('Nome: ', err.error);
                console.log('Mensagem: ', err.error_description);
            });
    } catch (error) {
        console.log('Código: ', error.code);
        console.log('Nome: ', error.error);
        console.log('Mensagem: ', error.error_description);
    }
});
