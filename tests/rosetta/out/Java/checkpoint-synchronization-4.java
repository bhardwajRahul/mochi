// Generated by Mochi compiler v0.10.30 on 2006-01-02T15:04:05Z
// checkpoint-synchronization-4.mochi
public class CheckpointSynchronization4 {
    public static void main(String[] args) {
        int nMech = 5;
        int detailsPerMech = 4;
        for (int mech = 1; mech < (nMech + 1); mech++) {
            Object id = mech;
            System.out.println("worker " + String.valueOf(id) + " contracted to assemble " + String.valueOf(detailsPerMech) + " details");
            System.out.println("worker " + String.valueOf(id) + " enters shop");
            int d = 0;
            while (d < detailsPerMech) {
                System.out.println("worker " + String.valueOf(id) + " assembling");
                System.out.println("worker " + String.valueOf(id) + " completed detail");
                d = (int)(d + 1);
            }
            System.out.println("worker " + String.valueOf(id) + " leaves shop");
            System.out.println("mechanism " + String.valueOf(mech) + " completed");
        }
    }
}
