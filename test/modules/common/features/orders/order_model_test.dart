import 'package:flutter_test/flutter_test.dart';

import 'package:diyafatukum/modules/common/features/orders/data/model/order_model.dart';

void main() {
  test('parses payment_received as a current provider order status', () {
    final order = OrderModel.fromJson({'id': 14, 'status': 'payment_received'});

    expect(order.activeStatus, OrderTimelineStatus.paymentReceived);
    expect(order.tabStatus, OrderTabStatus.current);
    expect(order.nextProviderStatus, OrderTimelineStatus.preparing);
    expect(
      order.timeline
          .firstWhere(
            (step) => step.status == OrderTimelineStatus.paymentReceived,
          )
          .current,
      isTrue,
    );
  });
}
