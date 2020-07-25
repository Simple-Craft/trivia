import { Model, Column, Table, PrimaryKey, CreatedAt, UpdatedAt, AutoIncrement, Default, DataType, BelongsTo } from "sequelize-typescript";
import Category from "./Category.model"

export enum ApprovalState {
    Pending,
    Approved,
    Rejected
}

@Table
export default class Question extends Model<Question> {
    @AutoIncrement
    @PrimaryKey
    @Column
    id: number;

    @Column(DataType.TEXT)
    question: string;

    @Column
    correctAnswer: string;

    @Column(DataType.TEXT)
    get wrongAnswers(): string[] {
        const json = this.getDataValue('wrongAnswers')
        // @ts-ignore
        return JSON.parse(json)
    }

    set wrongAnswers(value: string[]) {
        const json = JSON.stringify(value)
        // @ts-ignore
        this.setDataValue('wrongAnswers', json)
    }

    @BelongsTo(() => Category)
    category: Category;

    @Default(false)
    @Column(DataType.TINYINT)
    approvalState: number;

    @CreatedAt
    createdAt: Date;

    @UpdatedAt
    updatedAt: Date;
}