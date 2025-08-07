import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/order_repository.dart';
import '../../data/models/order_isar.dart';
import '../../../cart/data/models/cart_item_isar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// Repository provider
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository();
});

// Orders list provider for current user
final userOrdersProvider = FutureProvider<List<OrderIsar>>((ref) async {
  final user = ref.watch(authUserProvider);
  if (user == null) return [];
  
  final repository = ref.watch(orderRepositoryProvider);
  return repository.getOrdersByUserId(user.userId);
});

// All orders provider (for admin)
final allOrdersProvider = FutureProvider<List<OrderIsar>>((ref) async {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.getAllOrders();
});

// Order by ID provider
final orderByIdProvider = Provider.family<AsyncValue<OrderIsar?>, String>((ref, orderId) {
  final user = ref.watch(authUserProvider);
  final isAdmin = ref.watch(isAdminProvider);
  
  if (user == null) return const AsyncValue.data(null);
  
  if (isAdmin) {
    final allOrders = ref.watch(allOrdersProvider);
    return allOrders.when(
      data: (orders) {
        try {
          final order = orders.firstWhere((o) => o.orderId == orderId);
          return AsyncValue.data(order);
        } catch (e) {
          return const AsyncValue.data(null);
        }
      },
      loading: () => const AsyncValue.loading(),
      error: (error, stack) => AsyncValue.error(error, stack),
    );
  } else {
    final userOrders = ref.watch(userOrdersProvider);
    return userOrders.when(
      data: (orders) {
        try {
          final order = orders.firstWhere((o) => o.orderId == orderId);
          return AsyncValue.data(order);
        } catch (e) {
          return const AsyncValue.data(null);
        }
      },
      loading: () => const AsyncValue.loading(),
      error: (error, stack) => AsyncValue.error(error, stack),
    );
  }
});

// Order management state
class OrderManagementState {
  final bool isLoading;
  final String? error;
  final String? successMessage;

  const OrderManagementState({
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  OrderManagementState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return OrderManagementState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}

// Order management notifier
class OrderManagementNotifier extends StateNotifier<OrderManagementState> {
  final OrderRepository repository;
  final Ref ref;

  OrderManagementNotifier(this.repository, this.ref) : super(const OrderManagementState());

  Future<bool> createOrder({
    required List<CartItemIsar> items,
    required String deliveryAddress,
    required String paymentMethod,
    String? specialInstructions,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final user = ref.read(authUserProvider);
      if (user == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'User not authenticated',
        );
        return false;
      }

      final order = OrderIsar()
        ..orderId = DateTime.now().millisecondsSinceEpoch.toString()
        ..userId = user.userId
        ..customerName = user.displayName
        ..customerEmail = user.email
        ..customerPhone = user.phoneNumber
        ..items = items.map((item) => {
          'productId': item.productId,
          'name': item.name,
          'price': item.price,
          'quantity': item.quantity,
          'category': item.category,
        }).toList()
        ..totalAmount = items.fold(0.0, (sum, item) => sum + (item.price * item.quantity))
        ..status = 'pending'
        ..deliveryAddress = deliveryAddress
        ..paymentMethod = paymentMethod
        ..specialInstructions = specialInstructions ?? ''
        ..orderDate = DateTime.now()
        ..estimatedDeliveryDate = DateTime.now().add(const Duration(days: 1));

      await repository.addOrder(order);
      
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Order placed successfully!',
      );
      
      // Refresh orders list
      ref.invalidate(userOrdersProvider);
      
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create order: ${e.toString()}',
      );
      return false;
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      await repository.updateOrderStatus(orderId, newStatus);
      
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Order status updated successfully!',
      );
      
      // Refresh orders lists
      ref.invalidate(userOrdersProvider);
      ref.invalidate(allOrdersProvider);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update order status: ${e.toString()}',
      );
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      await repository.updateOrderStatus(orderId, 'cancelled');
      
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Order cancelled successfully!',
      );
      
      // Refresh orders lists
      ref.invalidate(userOrdersProvider);
      ref.invalidate(allOrdersProvider);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to cancel order: ${e.toString()}',
      );
    }
  }

  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}

final orderManagementProvider = StateNotifierProvider<OrderManagementNotifier, OrderManagementState>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return OrderManagementNotifier(repository, ref);
});

// Order statistics provider (for admin)
final orderStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final allOrders = ref.watch(allOrdersProvider);
  
  return allOrders.when(
    data: (orders) {
      final today = DateTime.now();
      final thisMonth = DateTime(today.year, today.month);
      
      final todayOrders = orders.where((o) => 
        o.orderDate.year == today.year &&
        o.orderDate.month == today.month &&
        o.orderDate.day == today.day
      ).length;
      
      final monthlyOrders = orders.where((o) => 
        o.orderDate.year == thisMonth.year &&
        o.orderDate.month == thisMonth.month
      ).length;
      
      final monthlyRevenue = orders
        .where((o) => 
          o.orderDate.year == thisMonth.year &&
          o.orderDate.month == thisMonth.month &&
          o.status != 'cancelled'
        )
        .fold(0.0, (sum, order) => sum + order.totalAmount);
      
      final pendingOrders = orders.where((o) => o.status == 'pending').length;
      
      return {
        'todayOrders': todayOrders,
        'monthlyOrders': monthlyOrders,
        'monthlyRevenue': monthlyRevenue,
        'pendingOrders': pendingOrders,
      };
    },
    loading: () => {
      'todayOrders': 0,
      'monthlyOrders': 0,
      'monthlyRevenue': 0.0,
      'pendingOrders': 0,
    },
    error: (_, __) => {
      'todayOrders': 0,
      'monthlyOrders': 0,
      'monthlyRevenue': 0.0,
      'pendingOrders': 0,
    },
  );
});