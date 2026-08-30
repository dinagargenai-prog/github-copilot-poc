trigger AccountTrigger on Account (
    after insert,
    after update
) {
    AccountTriggerHandler handler =
        new AccountTriggerHandler();

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            handler.onAfterInsert(Trigger.new);
        }

        if (Trigger.isUpdate) {
            handler.onAfterUpdate(
                Trigger.new,
                Trigger.oldMap
            );
        }
    }
}
