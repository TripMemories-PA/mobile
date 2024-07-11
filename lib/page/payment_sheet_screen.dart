import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';

import '../api/buy_ticket/buy_ticket_service.dart';
import '../api/buy_ticket/model/query/buy_ticket_query.dart';
import '../api/buy_ticket/model/response/buy_ticket_response.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/cart/cart_bloc.dart';
import '../component/stripe/billing_adress_form.dart';
import '../component/stripe/loading_button.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../utils/messenger.dart';

class PaymentScreen extends HookWidget {
  const PaymentScreen({
    super.key,
    required this.cartBloc,
  });

  final CartBloc cartBloc;

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController(
      text: context.read<AuthBloc>().state.user?.lastname,
    );
    final emailController = useTextEditingController(
      text: context.read<AuthBloc>().state.user?.email,
    );
    final phoneController = useTextEditingController();
    final cityController = useTextEditingController();
    final countryController = useTextEditingController();
    final line1Controller = useTextEditingController();
    final line2Controller = useTextEditingController();
    final stateController = useTextEditingController();
    final postalCodeController = useTextEditingController();
    final BillingDetailsControllers controllers = BillingDetailsControllers(
      nameController: nameController,
      emailController: emailController,
      phoneController: phoneController,
      cityController: cityController,
      countryController: countryController,
      line1Controller: line1Controller,
      line2Controller: line2Controller,
      stateController: stateController,
      postalCodeController: postalCodeController,
    );
    final step = useState(0);
    final billingDetails = useState<BillingDetails?>(null);
    return Scaffold(
      appBar: AppBar(
        title: Text(StringConstants().payment),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            10.ph,
            Text(
              '${StringConstants().total}: ${cartBloc.state.totalPrice.toStringAsFixed(2)} €',
            ),
            10.ph,
            Stepper(
              controlsBuilder: emptyControlBuilder,
              currentStep: step.value,
              steps: [
                Step(
                  title: Text(
                    StringConstants().billingDetails,
                  ),
                  content: Column(
                    children: [
                      _buildBillingDetails(billingDetails, controllers),
                      LoadingButton(
                        onPressed: () async {
                          final BillingDetails? billingDetailsValue =
                              billingDetails.value;
                          if (billingDetailsValue == null) {
                            Messenger.showSnackBarError(
                              StringConstants().fillBillingDetails,
                            );
                          } else {
                            initPaymentSheet(
                              step,
                              billingDetailsValue,
                              context,
                            );
                          }
                        },
                        text: StringConstants().initPayment,
                      ),
                    ],
                  ),
                ),
                Step(
                  title: Text(StringConstants().confirmPayment),
                  content: LoadingButton(
                    onPressed: () => confirmPayment(step).then(
                      (value) => {
                        if (value)
                          {
                            context.pop(),
                            context.read<CartBloc>().add(
                                  ClearCart(),
                                ),
                          },
                      },
                    ),
                    text: StringConstants().payNow,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingDetails(
    ValueNotifier<BillingDetails?> billingDetails,
    BillingDetailsControllers controllers,
  ) {
    if (billingDetails.value != null) {
      return Column(
        children: [
          Text('Name: ${billingDetails.value?.name}'),
          10.ph,
          Text('Email: ${billingDetails.value?.email}'),
          10.ph,
          Text('Phone: ${billingDetails.value?.phone}'),
          10.ph,
          Text('Address: ${billingDetails.value?.address?.city}'),
          10.ph,
          Text('Country: ${billingDetails.value?.address?.country}'),
          10.ph,
          Text('Line 1: ${billingDetails.value?.address?.line1}'),
          20.ph,
          ElevatedButton(
            onPressed: () => billingDetails.value = null,
            child: Text(StringConstants().deleteBillingDetails),
          ),
        ],
      );
    } else {
      return BillingDetailsForm(
        onSubmit: (BillingDetails value) {
          billingDetails.value = value;
        },
        controllers: controllers,
      );
    }
  }

  Future<void> initPaymentSheet(
    ValueNotifier<int> step,
    BillingDetails billingDetails,
    BuildContext context,
  ) async {
    try {
      final Color primaryColor = Theme.of(context).colorScheme.primary;
      final Color surfaceColor = Theme.of(context).colorScheme.surface;

      final List<BuyTicketQueryElement> tickets = [];
      for (final cartElement in cartBloc.state.cartElements) {
        tickets.add(
          BuyTicketQueryElement(
            id: cartElement.articles.first.id,
            quantity: cartElement.articles.length,
          ),
        );
      }
      final BuyTicketQuery buyTicketQuery = BuyTicketQuery(tickets: tickets);

      // 1. create payment intent on the server
      final BuyTicketResponse data =
          await BuyTicketService().buyTicket(tickets: buyTicketQuery);

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Main params
          paymentIntentClientSecret: data.paymentIntent,
          merchantDisplayName: 'Trip Memories payment [DEMO]',
          // Customer params
          returnURL: 'flutterstripe://redirect',

          // Extra params
          primaryButtonLabel: StringConstants().payNow,
          applePay: const PaymentSheetApplePay(
            merchantCountryCode: 'FR',
          ),
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'FR',
            testEnv: true,
          ),
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              background: surfaceColor,
              primary: primaryColor,
              componentBorder: Colors.black,
            ),
            shapes: PaymentSheetShape(
              borderWidth: 4,
              shadow: PaymentSheetShadowParams(color: primaryColor),
            ),
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              shapes: const PaymentSheetPrimaryButtonShape(blurRadius: 8),
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: surfaceColor,
                  text: primaryColor,
                  border: Colors.black,
                ),
              ),
            ),
          ),
          billingDetails: billingDetails,
        ),
      );
      step.value = 1;
    } catch (e) {
      Messenger.showSnackBarError(StringConstants().errorOccurred);
      rethrow;
    }
  }

  Future<bool> confirmPayment(
    ValueNotifier<int> step,
  ) async {
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();

      step.value = 0;
      Messenger.showSnackBarSuccess(StringConstants().paymentSuccess);
      return true;
    } on Exception catch (e) {
      if (e is StripeException) {
        if (e.error.code.index == FailureCode.Canceled.index) {
          Messenger.showSnackBarError(
            StringConstants().paymentCanceled,
          );
        } else {
          Messenger.showSnackBarError(
            StringConstants().errorOccurredFromStripe,
          );
        }
      } else {
        Messenger.showSnackBarError(StringConstants().errorOccurred);
      }
      return false;
    }
  }
}

Container emptyControlBuilder(_, __) {
  return Container();
}

class BillingDetailsControllers {
  BillingDetailsControllers({
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.cityController,
    required this.countryController,
    required this.line1Controller,
    required this.line2Controller,
    required this.stateController,
    required this.postalCodeController,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController cityController;
  final TextEditingController countryController;
  final TextEditingController line1Controller;
  final TextEditingController line2Controller;
  final TextEditingController stateController;
  final TextEditingController postalCodeController;
}
