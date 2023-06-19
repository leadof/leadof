import {
  // importProvidersFrom,
  mergeApplicationConfig,
  ApplicationConfig,
} from '@angular/core';
import { provideServerRendering } from '@angular/platform-server';
// import { IonicServerModule } from '@ionic/angular-server';
import { config as appConfig } from './app.config';

// importProvidersFrom(IonicServerModule),
const serverConfig: ApplicationConfig = {
  providers: [provideServerRendering()],
};

export const config = mergeApplicationConfig(appConfig, serverConfig);
