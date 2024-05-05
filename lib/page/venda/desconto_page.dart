import 'package:flutter/material.dart';
import '../../model/order.dart';

class DescontoPage extends StatefulWidget {
  final Order order;

  const DescontoPage({Key? key, required this.order}) : super(key: key);

  @override
  _DescontoPageState createState() => _DescontoPageState();
}

class _DescontoPageState extends State<DescontoPage> {
  bool isPercent = true;
  TextEditingController _descontoController = TextEditingController();
  double resultadoFinal = 0.0;
  bool _discountValid = true; // Flag for discount validation

  @override
  void initState() {
    super.initState();
    _descontoController.addListener(_calculateFinalTotal);
  }

  @override
  void dispose() {
    _descontoController.dispose();
    super.dispose();
  }

  void _calculateFinalTotal() {
    double desconto = double.tryParse(_descontoController.text) ?? 0.0;
    if (isPercent) {
      resultadoFinal =
          double.parse(widget.order.total) - (double.parse(widget.order.total) * desconto / 100);
    } else {
      resultadoFinal = double.parse(widget.order.total) - desconto;
    }

    // Validate discount
    _discountValid = _validateDiscount(desconto);

    setState(() {});
  }

  bool _validateDiscount(double desconto) {
    if (isPercent) {
      return desconto >= 0 &&
          desconto <= 100; // Percent discount must be between 0% and 100%
    } else {
      return desconto >= 0 &&
          desconto <=
              double.parse(widget.order.total); // R$ discount cannot exceed order total
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Desconto'),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Tipo de desconto: '),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButton<bool>(
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 36,
                      elevation: 16,
                      underline: SizedBox(),
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      value: isPercent,
                      onChanged: (value) {
                        setState(() {
                          isPercent = value!;
                          _discountValid = true;
                        });
                        _calculateFinalTotal();
                      },
                      items: [
                        DropdownMenuItem<bool>(
                          value: true,
                          child: Text('%'),
                        ),
                        DropdownMenuItem<bool>(
                          value: false,
                          child: Text('R\$'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descontoController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Valor do desconto',
                  errorText: _discountValid
                      ? null
                      : "O valor do desconto não pode ser maior que o valor da venda",
                ),
              ),
              SizedBox(height: 16),
              _discountValid == true
                  ? Text(
                      'Total: R\$ ${widget.order.total} - Desconto: ${isPercent ? "${_descontoController.text} % " : "R\$ ${_descontoController.text}"} =  ${resultadoFinal.toStringAsFixed(2)} R\$',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  : Text(
                      'Total: R\$ ${widget.order.total}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _discountValid
                        ? () {
                            double desconto =
                                double.parse(_descontoController.text);
                            widget.order.desconto = desconto.toString();
                            widget.order.tipoDesconto = isPercent
                                ? TipoDesconto.Percentual
                                : TipoDesconto
                                    .Dinheiro;
                            widget.order.total = resultadoFinal.toString();
                            Navigator.pop(context, widget.order);
                          }
                        : null,
                    child: Text('APLICAR DESCONTO'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _discountValid ? null : Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
