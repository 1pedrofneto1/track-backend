import { join } from 'path';

import { ApolloDriver, ApolloDriverConfig } from '@nestjs/apollo';
import { Module } from '@nestjs/common';
import { GraphQLModule } from '@nestjs/graphql';

import { AppResolver } from './app.resolver';
import { PrismaModule } from './shared/database/prisma.module';

@Module({
  imports: [
    PrismaModule,
    GraphQLModule.forRoot<ApolloDriverConfig>({
      driver: ApolloDriver,
      autoSchemaFile: join(process.cwd(), 'docs/graphql/schema.gql'),
      sortSchema: true,
      playground: Boolean(process.env.GRAPHQL_PLAYGROUND),
      introspection: Boolean(process.env.GRAPHQL_PLAYGROUND),
    }),
  ],
  providers: [AppResolver],
})
export class AppModule {}
