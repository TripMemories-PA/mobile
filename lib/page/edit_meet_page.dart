import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../api/meet/meet_service.dart';
import '../api/meet/model/query/create_meet_meeting_query.dart';
import '../api/meet/model/query/create_meet_reduction_query.dart';
import '../api/ticket/ticket_service.dart';
import '../bloc/meet/meet_bloc.dart';
import '../bloc/ticket_bloc/ticket_bloc.dart';
import '../component/custom_card.dart';
import '../component/ticket_card.dart';
import '../constants/string_constants.dart';
import '../dto/meet_bloc_and_obj_dto.dart';
import '../num_extensions.dart';
import '../object/ticket.dart';
import '../repository/meet/meet_repository.dart';
import '../repository/ticket/ticket_repository.dart';
import '../utils/field_validator.dart';

class EditMeetPage extends HookWidget {
  const EditMeetPage({super.key, required this.meetBlocAndObjDTO});

  final MeetBlocAndObjDTO meetBlocAndObjDTO;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MeetBloc(
        meetRepository: RepositoryProvider.of<MeetRepository>(context),
        meetService: MeetService(),
      )..add(GetPoiMeet(poiId: meetBlocAndObjDTO.poi.id, isRefresh: true)),
      child: BlocConsumer<MeetBloc, MeetState>(
        listener: (context, state) {
          if (state.postMeetStatus == PostMeetStatus.posted) {
            meetBlocAndObjDTO.meetBloc.add(
              GetPoiMeet(
                poiId: meetBlocAndObjDTO.poi.id,
                isRefresh: true,
              ),
            );
            context.pop();
          }
        },
        builder: (context, state) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                leading: const SizedBox.shrink(),
                title: Text(StringConstants().createMeet),
                actions: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
                centerTitle: true,
                bottom: TabBar(
                  tabs: [
                    Tab(text: StringConstants().meetPeople),
                    Tab(text: StringConstants().haveReduction),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  _FormMeeting(meetBlocAndObjDTO: meetBlocAndObjDTO),
                  _FormReduction(meetBlocAndObjDTO: meetBlocAndObjDTO),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FormMeeting extends HookWidget {
  const _FormMeeting({required this.meetBlocAndObjDTO});

  final MeetBlocAndObjDTO meetBlocAndObjDTO;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final titleController =
        useTextEditingController(text: meetBlocAndObjDTO.meet?.title);
    final descriptionController =
        useTextEditingController(text: meetBlocAndObjDTO.meet?.description);
    final sizeController =
        useTextEditingController(text: meetBlocAndObjDTO.meet?.size.toString());
    final dateController =
        useTextEditingController(text: meetBlocAndObjDTO.meet?.date.toString());

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLines: 2,
                  controller: titleController,
                  decoration:
                      InputDecoration(labelText: StringConstants().title),
                  validator: (value) =>
                      FieldValidator.validateRequired(value: value),
                ),
                10.ph,
                TextFormField(
                  maxLines: 4,
                  controller: descriptionController,
                  decoration:
                      InputDecoration(labelText: StringConstants().description),
                  validator: (value) =>
                      FieldValidator.validateRequired(value: value),
                ),
                10.ph,
                TextFormField(
                  controller: sizeController,
                  decoration:
                      InputDecoration(labelText: StringConstants().groupSize),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final String? check =
                        FieldValidator.validateIntFormat(value);
                    if (check != null) {
                      return value;
                    } else {
                      if (int.parse(value!) < 2) {
                        return StringConstants().valueMustBeGreaterThanTwo;
                      } else {
                        if (int.parse(value) > 50) {
                          return StringConstants().valueMustBeLessThanFifty;
                        } else {
                          return null;
                        }
                      }
                    }
                  },
                ),
                10.ph,
                TextFormField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: StringConstants().date,
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                      locale: const Locale('fr', 'FR'),
                    );
                    if (pickedDate != null) {
                      final String dateFormated = DateFormat(
                        'EEEE d MMMM yyyy',
                        'fr_FR',
                      ).format(pickedDate.toLocal());
                      dateController.text = dateFormated;
                    }
                  },
                  validator: (value) =>
                      FieldValidator.validateRequired(value: value),
                ),
                20.ph,
                ElevatedButton(
                  onPressed: () {
                    if (context.read<MeetBloc>().state.postMeetStatus ==
                        PostMeetStatus.loading) {
                      return;
                    }
                    if (formKey.currentState!.validate()) {
                      DateTime date;
                      try {
                        final DateFormat dateFormat = DateFormat(
                          'EEEE d MMMM yyyy',
                          'fr_FR',
                        );
                        date = dateFormat.parse(dateController.text);
                      } catch (e) {
                        date = DateTime.now();
                      }
                      final CreateMeetMeetingQuery query =
                          CreateMeetMeetingQuery(
                        title: titleController.text,
                        description: descriptionController.text,
                        size: int.parse(sizeController.text),
                        date: date,
                        poiId: meetBlocAndObjDTO.poi.id,
                      );
                      context.read<MeetBloc>().add(
                            PostMeetFromPoiPage(
                              query: query,
                              poiId: meetBlocAndObjDTO.poi.id,
                            ),
                          );
                    }
                  },
                  child: Text(StringConstants().createMeet),
                ),
                if (context.read<MeetBloc>().state.postMeetStatus ==
                    PostMeetStatus.loading)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FormReduction extends HookWidget {
  const _FormReduction({required this.meetBlocAndObjDTO});

  final MeetBlocAndObjDTO meetBlocAndObjDTO;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final titleController =
        useTextEditingController(text: meetBlocAndObjDTO.meet?.title);
    final descriptionController =
        useTextEditingController(text: meetBlocAndObjDTO.meet?.description);
    final dateController =
        useTextEditingController(text: meetBlocAndObjDTO.meet?.date.toString());
    final ValueNotifier<Ticket?> selectedTicket = useState(null);

    return BlocProvider(
      create: (context) => TicketBloc(
        ticketRepository: RepositoryProvider.of<TicketRepository>(context),
        ticketService: TicketService(),
      )..add(
          GetTicketsEvent(monumentId: meetBlocAndObjDTO.poi.id),
        ),
      child: BlocBuilder<TicketBloc, TicketState>(
        builder: (context, state) {
          final List<Ticket>? tickets = state.tickets;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                        validator: (value) =>
                            FieldValidator.validateRequired(value: value),
                      ),
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                        validator: (value) =>
                            FieldValidator.validateRequired(value: value),
                      ),
                      TextFormField(
                        controller: dateController,
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                            locale: const Locale('fr', 'FR'),
                          );
                          if (pickedDate != null) {
                            final String dateFormated = DateFormat(
                              'EEEE d MMMM yyyy',
                              'fr_FR',
                            ).format(pickedDate.toLocal());
                            dateController.text = dateFormated;
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a date';
                          }
                          return null;
                        },
                      ),
                      20.ph,
                      if (tickets != null)
                        selectedTicket.value == null
                            ? ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      child: CustomCard(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.8,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        content: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                StringConstants().selectTicket,
                                              ),
                                              Expanded(
                                                child: ListView.builder(
                                                  itemCount: tickets.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        selectedTicket.value =
                                                            tickets[index];
                                                        context.pop();
                                                      },
                                                      child: TicketCardAdmin(
                                                        article: tickets[index],
                                                        onlyDemo: true,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(StringConstants().selectTicket),
                              )
                            : Stack(
                                children: [
                                  _TicketCardCustom(
                                    article: selectedTicket.value!,
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      onPressed: () {
                                        selectedTicket.value = null;
                                      },
                                      icon: const Icon(Icons.close),
                                    ),
                                  ),
                                ],
                              ),
                      ElevatedButton(
                        onPressed: () {
                          if (selectedTicket.value == null) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                                content: Text(
                                  StringConstants().pleaseSelectATicket,
                                  textAlign: TextAlign.center,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      context.pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            if (formKey.currentState!.validate() &&
                                selectedTicket.value != null) {
                              DateTime date;
                              try {
                                final DateFormat dateFormat = DateFormat(
                                  'EEEE d MMMM yyyy',
                                  'fr_FR',
                                );
                                date = dateFormat.parse(dateController.text);
                              } catch (e) {
                                date = DateTime.now();
                              }
                              final CreateMeeReductionQuery query =
                                  CreateMeeReductionQuery(
                                title: titleController.text,
                                description: descriptionController.text,
                                date: date,
                                poiId: meetBlocAndObjDTO.poi.id,
                                ticketId: selectedTicket.value!.id,
                              );
                              context.read<MeetBloc>().add(
                                    PostMeetFromPoiPage(
                                      query: query,
                                      poiId: meetBlocAndObjDTO.poi.id,
                                    ),
                                  );
                            }
                          }
                        },
                        child: Text(StringConstants().createMeet),
                      ),
                      if (context.read<MeetBloc>().state.postMeetStatus ==
                          PostMeetStatus.loading)
                        const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TicketCardCustom extends StatelessWidget {
  const _TicketCardCustom({
    required this.article,
  });

  final Ticket article;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      borderColor: Theme.of(context).colorScheme.tertiary,
      content: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 200,
              child: _buildTicketImage(context),
            ),
            10.ph,
            AutoSizeText(
              article.title,
              minFontSize: 5,
              maxLines: 2,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            10.ph,
            AutoSizeText(
              article.description,
              minFontSize: 2,
              maxFontSize: 10,
              maxLines: 3,
            ),
            10.ph,
            Row(
              children: [
                Text(
                  '${article.price} €',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 30,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Stack _buildTicketImage(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              15,
            ),
            child: Image.network(
              article.poi.cover.url,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(
              211,
              211,
              211,
              0.7,
            ),
            borderRadius: BorderRadius.circular(
              15,
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.5,
          width: double.infinity,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width * 0.05,
            ),
            child: Image.asset('assets/images/ticket.png'),
          ),
        ),
      ],
    );
  }
}
