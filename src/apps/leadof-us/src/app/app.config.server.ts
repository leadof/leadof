import {
  importProvidersFrom,
  mergeApplicationConfig,
  ApplicationConfig,
} from '@angular/core';
import { provideServerRendering } from '@angular/platform-server';
import { IonicServerModule } from '@ionic/angular-server';
import { config as appConfig } from './app.config';

const serverConfig: ApplicationConfig = {
  providers: [importProvidersFrom(IonicServerModule), provideServerRendering()],
};

export const config = mergeApplicationConfig(appConfig, serverConfig);
