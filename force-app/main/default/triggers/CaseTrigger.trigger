trigger CaseTrigger on Case (
    after insert,
    after update
) {
    CaseTriggerAfterHandler handler =
        new CaseTriggerAfterHandler();

    if (Trigger.isAfter) {

        if (Trigger.isInsert) {
            handler.onAfterInsert(
                Trigger.new
            );
        }

        if (Trigger.isUpdate) {
            handler.onAfterUpdate(
                Trigger.new,
                Trigger.oldMap
            );
        }
    }
}