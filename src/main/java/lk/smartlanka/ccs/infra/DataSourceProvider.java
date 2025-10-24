package lk.smartlanka.ccs.infra;

import javax.sql.DataSource;

public class DataSourceProvider {
  public static DataSource getDataSource() {
    return AppConfig.getDataSource();
  }
}